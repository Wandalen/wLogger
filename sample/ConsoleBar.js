
if( typeof module !== 'undefined' )
try
{
  require( 'wLogger' );
}
catch( err )
{
  require( '../staging/dwtools/abase/printer/printer/Logger.s' );
}

var _ = wTools;

/*  By default logger cant use console as input & output device in one time, by using consoleBar we can
get all console output and print it through outputLogger without recursion */

var outputLogger = new wLogger();
var barLogger = new wLogger({ output : null });

/*
consoleBar redirects all console output to outputLogger through barLogger that
makes other loggers connected after it unable to receive messages from console,
outputLogger prints messages through original console methods( channels ).
*/

/*
     barring       ordinary       unbarring
 console -> barLogger -> outputLogger -> console
   ^
   |
 others

unbarring link is not transitive, but terminating
so no cycle
*/

wLogger.consoleBar
({
  barLogger : barLogger,
  outputLogger : outputLogger,
  bar : 1
});

console.log( 'Message from console' );
