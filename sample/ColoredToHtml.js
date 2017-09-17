
if( typeof module !== 'undefined' )
require( '../staging/dwtools/abase/printer/printer/Logger.s' );


var _ = wTools;
var fg = _.strColor.fg;
var bg = _.strColor.bg;


var src = [ fg( 'red text', 'red' ), bg( 'red background', 'red' ) ];
var html = wLogger.coloredToHtml( src );
console.log( '\nwLogger.coloredToHtml: ', html );
// <span style='color:rgba( 255, 0, 0, 1 );'>red text</span><span style='background:rgba( 255, 0, 0, 1 );'>red background</span>

var src = [ 'some text',_.strColor.fg( 'text','red' ),_.strColor.bg( 'text','yellow' ),'some text' ];
var html = wLogger.coloredToHtml( src );
console.log( '\nwLogger.coloredToHtml: ', html );
//some text <span style='color:rgba( 255, 0, 0, 1 );'>text</span><span style='background:rgba( 255, 255, 0, 1 );'>text</span> some text

var src = fg( '\nred text' + fg( 'yellow text', 'yellow' ) + 'red text', 'red' );
var html = wLogger.coloredToHtml( src );
console.log( '\nwLogger.coloredToHtml: ', html );
// <span style='color:rgba( 255, 0, 0, 1 );'><br>red text<span style='color:rgba( 255, 255, 0, 1 );'>yellow text</span>red text</span>

var src = bg( '\nred background' + bg( 'yellow background', 'yellow' ) + 'red background', 'red' );
var html = wLogger.coloredToHtml( src );
console.log( '\nwLogger.coloredToHtml: ', html );
// <span style='background:rgba( 255, 0, 0, 1 );'><br>red background<span style='background:rgba( 255, 255, 0, 1 );'>yellow background</span>red background</span>

var src = '#background : red#red#background : blue#blue#background : default#red#background : default#';
var html = wLogger.coloredToHtml( src );
console.log( '\nwLogger.coloredToHtml: ', html );
// <span style='background:rgba( 255, 0, 0, 1 );'>red<span style='background:rgba( 0, 0, 255, 1 );'>blue</span>red</span>

var src = _.strColor.bg( 'red' + _.strColor.bg( 'blue','blue' ) + 'red','red' );
var html = wLogger.coloredToHtml( src );
console.log( '\nwLogger.coloredToHtml: ', html );
// <span style='background:rgba( 255, 0, 0, 1 );'>red<span style='background:rgba( 0, 0, 255, 1 );'>blue</span>red</span>
