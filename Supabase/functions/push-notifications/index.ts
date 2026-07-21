import { createClient } from "https://esm.sh/@supabase/supabase-js@2";
import { importPKCS8, SignJWT } from "npm:jose@5";

const supabase = createClient(
  Deno.env.get("SUPABASE_URL")!,
  Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!,
);

Deno.serve(async (request) => {
  const row = await request.json();
  const notification = row.record ?? row;
  const { data: tokens, error } = await supabase
    .from("device_tokens")
    .select("token,matches_enabled,messages_enabled,reminders_enabled,product_updates_enabled")
    .eq("user_id", notification.recipient_user_id);
  if (error) return new Response(error.message, { status: 500 });

  const enabledKey: Record<string, string> = {
    match: "matches_enabled",
    message: "messages_enabled",
    reminder: "reminders_enabled",
    product_update: "product_updates_enabled",
  };
  const eligible = (tokens ?? []).filter((item) => item[enabledKey[notification.category]] !== false);
  if (!eligible.length) return Response.json({ sent: 0 });

  const privateKey = (Deno.env.get("APNS_PRIVATE_KEY") ?? "").replace(/\\n/g, "\n");
  const key = await importPKCS8(privateKey, "ES256");
  const jwt = await new SignJWT({})
    .setProtectedHeader({ alg: "ES256", kid: Deno.env.get("APNS_KEY_ID")! })
    .setIssuer(Deno.env.get("APNS_TEAM_ID")!)
    .setIssuedAt()
    .sign(key);

  const host = Deno.env.get("APNS_ENV") === "production"
    ? "https://api.push.apple.com"
    : "https://api.sandbox.push.apple.com";
  const bundleID = Deno.env.get("APNS_BUNDLE_ID")!;
  let sent = 0;
  for (const item of eligible) {
    const response = await fetch(`${host}/3/device/${item.token}`, {
      method: "POST",
      headers: {
        authorization: `bearer ${jwt}`,
        "apns-topic": bundleID,
        "apns-push-type": "alert",
        "apns-priority": "10",
      },
      body: JSON.stringify({
        aps: { alert: { title: notification.title, body: notification.body }, sound: "default" },
        ...notification.payload,
      }),
    });
    if (response.ok) sent += 1;
  }
  await supabase.from("notification_outbox").update({ processed_at: new Date().toISOString() }).eq("id", notification.id);
  return Response.json({ sent });
});
