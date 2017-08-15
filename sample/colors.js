require( 'wTools' );
require( 'wConsequence' );
require( '../staging/abase/printer/printer/Logger.s' );

var _ = wTools;
var colorNames = _.mapOwnKeys( _.color.ColorMapShell );

function shortColor( name )
{
  var parts = _.strSplit( name );
  if( parts[ 0 ] === 'light' )
  name = 'l.' + parts[ 1 ];

  return name;
}

function prepareTableInfo()
{
  function onWrite( data )
  {
    row[ shortColor( fg ) ].push( data.outputForTerminal[ 0 ] )
  }

  var table = [];
  var fg,bg;
  var row  = {};

  var silencedLogger = new wLogger
  ({
    output : null,
    onWrite : onWrite
  })
  for( var i = 0; i < colorNames.length; i++ )
  {
    fg = colorNames[ i ];
    row[ shortColor( fg ) ] = [];
    for( var j = 0; j < colorNames.length; j++ )
    {
      bg = colorNames[ j ];
      var coloredLine = _.strColor.bg( _.strColor.fg( 'xYz', fg ), bg );
      silencedLogger.log( coloredLine );
    }
    table.push( row );
    row = {};
  }

  return table;
}

function drawTable()
{
  var Table = require( 'cli-table2' );
  var info = prepareTableInfo();
  var o =
  {
    head : [ "fg/bg" ],
    colWidths : [ 9 ],
    rowAligns : [ 'left' ],
    colAligns : null,
    style:
    {
       compact : true,
      'padding-left': 0,
      'padding-right': 0
    },
  }

  colorNames.forEach( ( name, i ) => colorNames[ i ] = shortColor( name ) );
  o.head.push.apply( o.head, colorNames );

  o.colWidths.push.apply( o.colWidths, _.arrayFill({ times : colorNames.length / 2 , value : 5 }) )
  o.colWidths.push.apply( o.colWidths, _.arrayFill({ times : colorNames.length / 2 , value : 7 }) )

  o.rowAligns.push.apply( o.rowAligns, _.arrayFill({ times : colorNames.length , value : 'center' }) );
  o.colAligns = o.rowAligns;

  var table = new Table( o );
  table.push.apply( table, info );

  logger.log( table.toString() );
}

_.shell( 'npm i cli-table2' )
.doThen( () => drawTable() );

