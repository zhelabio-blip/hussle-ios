import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

Deno.serve(async (request) => {
  if (request.method !== "POST") {
    return new Response(JSON.stringify({ error: "Method not allowed" }), { status: 405 });
  }

  const supabaseUrl = Deno.env.get("SUPABASE_URL");
  const anonKey = Deno.env.get("SUPABASE_ANON_KEY");
  const serviceRoleKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY");
  const authorization = request.headers.get("Authorization");

  if (!supabaseUrl || !anonKey || !serviceRoleKey || !authorization) {
    return new Response(JSON.stringify({ error: "Server configuration is incomplete" }), { status: 500 });
  }

  const userClient = createClient(supabaseUrl, anonKey, {
    global: { headers: { Authorization: authorization } },
  });
  const adminClient = createClient(supabaseUrl, serviceRoleKey);

  const { data: userData, error: userError } = await userClient.auth.getUser();
  if (userError || !userData.user) {
    return new Response(JSON.stringify({ error: "Unauthorized" }), { status: 401 });
  }

  const userId = userData.user.id;
  const { data: dogs } = await adminClient.from("dogs").select("id").eq("owner_id", userId);
  const dogIds = (dogs ?? []).map((dog) => dog.id);

  if (dogIds.length > 0) {
    const { data: photos } = await adminClient.from("dog_photos").select("storage_path").in("dog_id", dogIds);
    const photoPaths = (photos ?? []).map((photo) => photo.storage_path).filter(Boolean);
    if (photoPaths.length > 0) await adminClient.storage.from("dog-photos").remove(photoPaths);

    const { data: docs } = await adminClient.from("vaccinations").select("document_path").in("dog_id", dogIds);
    const documentPaths = (docs ?? []).map((doc) => doc.document_path).filter(Boolean);
    if (documentPaths.length > 0) await adminClient.storage.from("vaccination-documents").remove(documentPaths);
  }

  const { error: deleteError } = await adminClient.auth.admin.deleteUser(userId);
  if (deleteError) {
    return new Response(JSON.stringify({ error: deleteError.message }), { status: 500 });
  }

  return new Response("{}", { status: 200, headers: { "Content-Type": "application/json" } });
});
