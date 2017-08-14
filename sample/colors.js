require( 'wTools' );
require( '../staging/abase/printer/printer/Logger.s' );

var _ = wTools;

var colorNames = _.mapOwnKeys( _.color.ColorMapShell );
var n = 1;
for( var i = 0; i < colorNames.length; i++ )
{
  var fg = colorNames[ i ];
  
  for( var j = colorNames.length - 1; j >= 0; --j )
  {
    var bg = colorNames[ j ];
    logger.foregroundColor = fg;
    logger.backgroundColor = bg;
    logger.log( '#' + n++, fg, ' - ', bg );
  }
}