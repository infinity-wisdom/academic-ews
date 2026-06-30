// ---------------------------------------------------------
// Shared Supabase client. Every page loads this after the
// Supabase JS library, then can use `window.supabaseClient`.
// ---------------------------------------------------------
const SUPABASE_URL = "https://nvokksfrzfdqgnnxmwzi.supabase.co";
const SUPABASE_ANON_KEY = "sb_publishable_mhjqbGCOM6HaqS8iVKhygQ_BfNbutD5";

window.supabaseClient = supabase.createClient(SUPABASE_URL, SUPABASE_ANON_KEY);
