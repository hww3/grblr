array get_ports()
{
#ifdef __APPLE__
  array pn = glob("cu.*", get_dir("/dev"));
  return pn;
#else
  return ({});
#endif
}


//! @param portname
//!   name of device (not including /dev)
//!
//! @param baud
//!   baud rate
//!
//! @param spec
//!   character length, stop-bits, parity: example="81N"
object get_port(string portname, int baud, string spec)
{
  object port;
  mapping opts;
  string bits, stop, parity;

  int res = sscanf(spec, "%[5678]%[12]%[NOE]", bits, stop, parity);
  if(res != 3)
    throw(Error.Generic("Serial.get_port(): invalid spec string \"" + spec + "\"\n"));

  opts = (["ispeed": baud, "ospeed": baud, "csize": (int)bits, "ECHO":0,"ICANON":0,"VMIN":0,"VTIME":0]);

  switch(parity)
  {
    case "N":
      opts->PARENB = 0;
      break;

    case "O":
      opts->PARENB = 1;
      opts->PARODD = 1;
      break;

    case "E":
      opts->PARENB = 1;
      opts->PARODD = 0;
      break;
  }

  switch(stop)
  {
    case "1":
      opts->CSTOPB = 0;
      break;

    case "2":
      opts->CSTOPB = 1;
      break;
  }


  port = Stdio.File(combine_path("/dev", portname));
  port->tcsetattr(opts);
  return port;
}
