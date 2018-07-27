
if( typeof module !== 'undefined' )
require( 'wTools' );

let _ = _global_.wTools;

_.include( 'wLogger' );
_.include( 'wColor' );

var fg = _.color.strFormatForeground;
var bg = _.color.strFormatBackground;

/* Sample shows how to print colorful text as html in different ways */

console.log( 'Creating printer with console as output and option writingToHtml which enables converting input into html.' )

var printer = new _.Logger({ output : console, writingToHtml : 1 });

printer.log( 'simplest input' );

/* using coloring directive: foreground */

printer.log( '#foreground : red#red#foreground : blue#blue#foreground : default#red#foreground : default#' )

/* same way but, by using shortcut _.color.strFormatForeground */

printer.log( fg( 'red text', 'red' ) );

/* combining two styles */

printer.log( bg( fg( 'black text on yellow background', 'black' ), 'yellow' ) );

