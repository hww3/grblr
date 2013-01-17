
import Public.ObjectiveC;
object NSApp;

int main(int argc, array argv)
{
  NSApp = Cocoa.NSApplication.sharedApplication();
  add_constant("NSApp", NSApp);
  NSApp->activateIgnoringOtherApps_(1);

  add_backend_to_runloop(Pike.DefaultBackend, 0.3);

//  add_module_path(getcwd());  
werror("module_path: %O\n", master()->pike_module_path);
werror("ports: %O\n",  Serial.get_ports());
  return AppKit()->NSApplicationMain(argc, argv);
//return 0;
}

