
if( typeof module !== 'undefined' )
{
  require( 'wTools' );

  var _ = _global_.wTools;

  _.include( 'wLogger' );
  _.include( 'wColor' );
}


let printer = new _.Logger({ output : console });

/**/

printer.log();
debugger
printer.log( 'Setting color through field:' );

printer.foregroundColor = 'red'; /* sets foreground color to red */
printer.log( 'red text' );
printer.foregroundColor = 'default'; /* sets foreground color to default */
printer.log( 'default text' );

printer.backgroundColor = 'red'; /* sets background color to red */
printer.log( 'red text' );
printer.backgroundColor = 'default'; /* sets background color to default */
printer.log( 'default text' );

/**/

printer.log();
printer.log( 'Providing color directives through input:' );
printer.log( '#foreground : red#' ); /* sets foreground color to red */
printer.log( 'red text' ); /* each call of log will print input in red color */
printer.log( '#foreground : default#' ); /* sets foreground color to default */
printer.log( 'default text' );

/**/

printer.log();
printer.log( 'Same result in one call:' );
printer.log( '#background : red#\nred text\n#background : default#\ndefault text' );

/**/

printer.log();
printer.log( 'Coloring is easier with shortcuts:' );
let fg = _.color.strFormatForeground;
let bg = _.color.strFormatBackground;
printer.log( '\n', fg( 'red text', 'red' ), 'default text' );

/**/

printer.log();
printer.log( 'Making combinations of two styles:' );
printer.log( '\n', bg( fg( 'black text on yellow background', 'black' ), 'yellow' ) );

/**/

printer.log();
printer.log( 'Colors are stackable:' );
printer.foregroundColor = 'red';
printer.foregroundColor = 'blue';
printer.foregroundColor = 'green';
printer.log( 'green text' )
printer.foregroundColor = 'default'; /* sets color to blue */
printer.log( 'blue text' );
printer.foregroundColor = 'default'; /* sets color to red */
printer.log( 'red text' );
printer.foregroundColor = 'default'; /* sets color to default */
printer.log( 'default text' )
printer.log();

/**/

printer.log();
printer.log( 'Stacking foreground color: red text between yellow' );
printer.log( '\n', fg( 'yellow text' + fg( ' red text ', 'red' ) + 'yellow text', 'yellow' ) );






