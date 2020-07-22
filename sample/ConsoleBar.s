
if( typeof module !== 'undefined' )
require( 'wTools' );

let _ = _global_.wTools;

_.include( 'wLogger' );

/*  By default logger cant use console as input & output device in one time, by using ConsoleBar we can
get all console output and print it through outputPrinter without recursion */

var outputPrinter = new _.Logger();
var barPrinter = new _.Logger({ output : null });

/*
ConsoleBar redirects all console output to outputPrinter through barPrinter that
makes other loggers connected after it unable to receive messages from console,
outputPrinter prints messages through original console methods( channels ).
*/

/*

     exclusiveOutput        ordinary      originalOutput
 console    ->    barPrinter  ->  outputPrinter   ->   console
   ^
   |
 others

originalOutput link is not transitive, but terminating
so no cycle


 console -> barPrinter -> outputPrinter -> defLogger -> console

*/

_.Logger.ConsoleBar
({
  barPrinter : barPrinter,
  outputPrinter : outputPrinter,
  on : 1
});

console.log( 'Message from console' );
