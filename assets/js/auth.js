// ---------------------------------------------------------
// Shared auth helpers. Load AFTER supabase-client.js.
// ---------------------------------------------------------

/**
 * Fetches the logged-in user's profile row (includes their role).
 * Returns null if nobody is logged in.
 */
async function getCurrentProfile() {
  const { data: { session } } = await window.supabaseClient.auth.getSession();
  if (!session) return null;

  const { data, error } = await window.supabaseClient
    .from("profiles")
    .select("*")
    .eq("id", session.user.id)
    .single();

  if (error) {
    console.error("Failed to load profile:", error.message);
    return null;
  }
  return data;
}

/**
 * Guards a page: redirects to `loginPath` if nobody is logged in,
 * or if their role isn't in `allowedRoles`.
 * Call this at the top of every protected page.
 * Returns the profile if access is allowed.
 */
async function requireRole(allowedRoles, loginPath = "login.html") {
  const profile = await getCurrentProfile();
  if (!profile || !allowedRoles.includes(profile.role)) {
    window.location.href = loginPath;
    return null;
  }
  return profile;
}

/**
 * Signs the current user out and sends them to the given page.
 */
async function signOutAndRedirect(redirectPath = "login.html") {
  await window.supabaseClient.auth.signOut();
  window.location.href = redirectPath;
}
