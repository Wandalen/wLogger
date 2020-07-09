
require( '../../../wtools/Tools.s' );

var _ = _global_.wTools

_.include( 'wConsequence' );
_.include( 'wLogger' );
_.include( 'wProcess' );

var colorNames =
[
  'white',
  'black',
  'green',
  'red',
  'yellow',
  'blue',
  'cyan',
  'magenta',
  'bright black',
  'dark yellow',
  'dark red',
  'dark magenta',
  'dark blue',
  'dark cyan',
  'dark green',
  'dark white'
]

//

function shortColor( name )
{
  var parts = _.strSplitNonPreserving({ src : name, preservingDelimeters : 0 });
  if( parts[ 0 ] === 'dark' )
  name = 'd.' + parts[ 1 ];

  if( parts[ 0 ] === 'bright' )
  name = 'b.' + parts[ 1 ];

  return name;
}

//

function prepareTableInfo()
{
  function onTransformEnd( data )
  {
    if( c <= colorNames.length / 2 )
    row1[ shortColor( fg ) ].push( data.outputForTerminal[ 0 ] );
    else
    row2[ shortColor( fg ) ].push( data.outputForTerminal[ 0 ] );
  }

  var table1 = [];
  var table2 = [];
  var fg,bg;
  var row1  = {};
  var row2  = {};
  var c = 0;

  var silencedLogger = new _.Logger
  ({
    output : null,
    onTransformEnd,
  })
  silencedLogger.diagnosingColor = 0;
  for( var i = 0; i < colorNames.length; i++ )
  {
    fg = colorNames[ i ];
    row1[ shortColor( fg ) ] = [];
    row2[ shortColor( fg ) ] = [];
    for( var j = 0; j < colorNames.length; j++ )
    {
      c++;
      bg = colorNames[ j ];
      var coloredLine = _.ct.bg( _.ct.fg( 'xYz', fg ), bg );
      silencedLogger.log( coloredLine );
    }
    table1.push( row1 );
    table2.push( row2 );
    row1 = {};
    row2 = {};
    c = 0;
  }

  return [ table1, table2 ];
}

//

function drawTable()
{
  var Table = require( 'cli-table2' );
  var tables = prepareTableInfo();
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
  o.head.push.apply( o.head, colorNames.slice( 0, colorNames.length / 2 ) );

  debugger;
  o.colWidths.push.apply( o.colWidths, _.longFill( [], 6,         colorNames.length / 2 ) )
  o.rowAligns.push.apply( o.rowAligns, _.longFill( [], 'center',  colorNames.length ) );

  // o.colWidths.push.apply( o.colWidths, _.longFillTimes( [] , colorNames.length / 2 , 6 ) )
  // o.rowAligns.push.apply( o.rowAligns, _.longFillTimes( [] , colorNames.length , 'center' ) );

  o.colAligns = o.rowAligns;

  /**/

  var table = new Table( o );
  table.push.apply( table, tables[ 0 ] );
  logger.log( table.toString() );

  /**/

  o.head = [ o.head[ 0 ] ];
  o.head.push.apply( o.head, colorNames.slice( colorNames.length / 2, colorNames.length) );
  var table = new Table( o );
  table.push.apply( table, tables[ 1 ] );
  logger.log( table.toString() );
}

drawTable();
