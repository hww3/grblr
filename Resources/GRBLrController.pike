import Public.ObjectiveC;

inherit Cocoa.NSObject;

string pref_file = combine_path(getenv("HOME"), ".grblr.preferences");
mapping preferences = ([]);

object MainWindow;
object portList;
object baudList;
object connectButton;

object grbl;

static void create()
{
werror("****\n****\n****\n****\n");
  ::create();
  register_preferences();
}

void register_preferences()
{
  load_preferences();
  add_preference("serialPort", "-");
  add_preference("baudRate", "9600");
  save_preferences();
}

void add_preference(string key, mixed value)
{
  if(!has_index(preferences, key)) preferences[key] = value;
}

void update_preference(string key, mixed value)
{
  preferences[key] = value;
  save_preferences();
}

void load_preferences()
{
  werror("loading preferences from %O\n", pref_file);
  if(file_stat(pref_file))
  {
    preferences = Standards.JSON.decode(Stdio.read_file(pref_file));
  }
}

void save_preferences()
{
  werror("saving preferences to %O\n", pref_file);
  Stdio.write_file(pref_file, Standards.JSON.encode(preferences));
}

void _finishedMakingConnections()
{        
   MainWindow->makeKeyAndOrderFront_(this);
   werror("**** _AWAKENING\n");
   array ports = Serial.get_ports();
   array bauds = ({"9600", "19200", "38400", "56800", "115600"});

   baudList->addItemsWithTitles_(bauds);
   baudList->selectItemAtIndex_(search(bauds, preferences->baudRate));
   portList->addItemsWithTitles_(ports);
   portList->selectItemAtIndex_(search(ports, preferences->serialPort));
}

void baudListSelected_(object w)
{
  string value = (string)w->selectedItem()->title();
  string old = preferences->baudRate;
  werror("selected: %O=%O\n", value, old);
  if(old != value)
  {
    update_preference("baudRate", value);
    if(grbl)
    {
      grbl = 0;
      connectButton->setEnabled_(1);
    }
  }
}
        
void portListSelected_(object w)
{
  string value = (string)w->selectedItem()->title();
  string old = preferences->serialPort;
  werror("selected: %O=%O\n", value, old);
  if(old != value)
  {
    update_preference("serialPort", value);
    if(grbl)
    {
      grbl = 0;
      connectButton->setEnabled_(1);
    }
  }
}

void connectPushed_(object w)
{
  if(preferences->serialPort != "-")
    connect_grbl();
  else throw(Error.Generic("No port selected.\n"));
}

void connect_grbl()
{
  grbl = GRBL.GRBL(preferences->serialPort, (int)preferences->baudRate);
  connectButton->setEnabled_(0);
}
