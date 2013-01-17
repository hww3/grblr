
Stdio.File con;

static void create(string port, int baudrate)
{
  if(!baudrate) throw(Error.Generic("Baud rate " + baudrate + " invalid.\n"));
  con = Serial.get_port(port, baudrate, "81N");

  verify_grbl();
}


void verify_grbl()
{
  write("verify_grbl()\n");
  con->write("$\n");
  string res = con->read(1024, 1);
  werror("res: %O\n", res);
  if(!res || !sizeof(res)) throw(Error.Generic("GRBL not present.\n"));
}
