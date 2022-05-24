import 'package:supabase/supabase.dart';

class BaseHandler {

  //Add your URL and Key
  static String supabaseUrl = "";
  static String supabaseKey =
      "";

  final client = SupabaseClient(supabaseUrl, supabaseKey);

  addData(String taskValue, bool statusValue) {
    var response = client
        .from("todo_table")
        .insert({"task": taskValue, "status": statusValue}).execute();
  }

  readData() async {
    var response = await client
        .from("todo_table")
        .select()
        .order("id", ascending: false)
        .execute();

    final datalist = response.data as List;

    return datalist;
  }

  updateData(int id, bool statusValue) {
    var response = client
        .from("todo_table")
        .update({"status": statusValue})
        .eq("id", id)
        .execute();
  }

  deleteData(int id) {
    var response = client.from("todo_table").delete().eq("id", id).execute();
  }
}
