import { createClient } from "@supabase/supabase-js";

const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL;
const supabaseAnonKey = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY;

export const supabase = createClient(supabaseUrl, supabaseAnonKey);

export const oldSupabase = createClient('https://alytqvwillylytpmdjai.supabase.co', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImFseXRxdndpbGx5bHl0cG1kamFpIiwicm9sZSI6ImFub24iLCJpYXQiOjE2NDY5MTk5MzUsImV4cCI6MTk2MjQ5NTkzNX0.8fLvoOki0tYbuxlQ333ABo4vopCEj7vjqXzaMWF5ieU');
