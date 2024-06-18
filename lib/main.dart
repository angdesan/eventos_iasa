import 'package:eventos_iasa/ui/exampleapp.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void>  main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://ykjxuirydqylyxznqjeq.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inlranh1aXJ5ZHF5bHl4em5xamVxIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTg0OTA5ODYsImV4cCI6MjAzNDA2Njk4Nn0.eHk4tF-A7WlvdHLFcv-u0G9C5z0PYnSJ4Bw7NhcVHxo',

  );
  runApp(Exampleapp());
}