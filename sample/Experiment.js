
if( typeof module !== 'undefined' )
{
  require( '../staging/abase/object/printer/printer/Logger.s' );
  require('../../wTools/staging/abase/component/StringTools.s')
}

var _ = wTools;

var logger = new wLogger();

logger.log( 'some text',_.strColor.fg( 'text','red' ),_.strColor.bg( 'text','yellow' ) )

logger.log( '#foreground : red#this is red text' );
logger.log( 'this is too#foreground : default#' );
logger.log( '#background : green#green background' );
logger.log( 'this is too#background : default#' );

// var _writeDoing = function( str )
// {
//   var self = this;
//
//   _.assert( arguments.length === 1 );
//
//   var res = [ '' ];
//   var i = 0;
//   str = str.split( '#' );
//   while( i< str.length )
//   {
//     var options =  str[ i ].split( ' : ' );
//     var style = options[ 0 ];
//     var color = options[ 1 ];
//
//     if( style === 'foreground')
//     {
//       res[ 0 ] +=`%c${ str[ i+1 ] }`;
//       res.push( `color:${color}` );
//     }
//     else if( style === 'background' )
//     {
//       res[ 0 ] +=`%c${ str[ i+1 ] }`;
//       res.push( `background:${color}` );
//     }
//     i+=1;
//   }
//
//   console.log( res[0],res[1],res[2] );
// }
//
// _writeDoing( '#foreground : red#text#background : red#text' );
