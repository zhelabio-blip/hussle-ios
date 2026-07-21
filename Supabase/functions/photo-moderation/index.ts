import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

const supabaseUrl = Deno.env.get("SUPABASE_URL")!;
const serviceRoleKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;
const webhookSecret = Deno.env.get("PHOTO_MODERATION_WEBHOOK_SECRET")!;
const supabase = createClient(supabaseUrl, serviceRoleKey, { auth: { persistSession: false } });

function hasAllowedSignature(bytes: Uint8Array): boolean {
  const jpeg = bytes.length > 3 && bytes[0] === 0xff && bytes[1] === 0xd8 && bytes[2] === 0xff;
  const png = bytes.length > 8 && bytes[0] === 0x89 && bytes[1] === 0x50 && bytes[2] === 0x4e && bytes[3] === 0x47;
  return jpeg || png;
}

Deno.serve(async (request) => {
  if (request.headers.get("x-hussle-webhook-secret") !== webhookSecret) {
    return new Response("Unauthorized", { status: 401 });
  }

  const payload = await request.json();
  const photoId = payload.photo_id ?? payload.record?.photo_id ?? payload.record?.id;
  if (!photoId) return new Response("Missing photo_id", { status: 400 });

  const { data: photo, error: photoError } = await supabase
    .from("dog_photos")
    .select("id, storage_path")
    .eq("id", photoId)
    .single();
  if (photoError || !photo) return new Response(photoError?.message ?? "Photo not found", { status: 404 });

  await supabase.from("photo_moderation_queue").update({ status: "processing", attempts: payload.attempts ?? 1 }).eq("photo_id", photoId);

  try {
    const { data, error } = await supabase.storage.from("dog-photos").download(photo.storage_path);
    if (error || !data) throw new Error(error?.message ?? "Download failed");
    const bytes = new Uint8Array(await data.arrayBuffer());
    const valid = bytes.byteLength > 0 && bytes.byteLength <= 8 * 1024 * 1024 && hasAllowedSignature(bytes);

    await supabase.from("dog_photos").update({ moderation_status: valid ? "approved" : "rejected" }).eq("id", photoId);
    await supabase.from("photo_moderation_queue").update({
      status: "completed",
      last_error: valid ? null : "Unsupported image signature or file larger than 8 MB",
      updated_at: new Date().toISOString()
    }).eq("photo_id", photoId);

    return Response.json({ photo_id: photoId, status: valid ? "approved" : "rejected" });
  } catch (error) {
    await supabase.from("photo_moderation_queue").update({
      status: "failed",
      last_error: String(error),
      updated_at: new Date().toISOString()
    }).eq("photo_id", photoId);
    return new Response(String(error), { status: 500 });
  }
});
