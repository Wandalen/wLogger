
try
{
  require( '../../../../wtools/Tools.s' );
}
catch( err )
{
  require( 'wTools' );
}

let _ = _global_.wTools

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

drawTable();
// drawTableOld();

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
  var fg, bg;
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
  var tables = prepareTableInfo();

  var o2 = Object.create( null );
  o2.topHead = [ 'fg/bg', ... colorNames.slice( 0, 8 ).map( ( name ) => shortColor( name ) ) ];
  o2.leftHead = [ 'fg/bg', ... colorNames.map( ( name ) => shortColor( name ) ) ];
  o2.onCellGet = onCellGet;
  o2.onLength = onLength;
  o2.data = tables[ 0 ];
  o2.dim = onTableDim( tables[ 0 ] );
  o2.colWidth = 9;
  o2.colSplits = 1;
  o2.style = 'doubleBorder';
  logger.log( _.strTable( o2 ).result );

  var o2 = Object.create( null );
  o2.topHead = [ 'fg/bg', ... colorNames.slice( 8, 16 ).map( ( name ) => shortColor( name ) ) ];
  o2.leftHead = [ 'fg/bg', ... colorNames.map( ( name ) => shortColor( name ) ) ];
  o2.onCellGet = onCellGet;
  o2.onLength = onLength;
  o2.data = tables[ 1 ];
  o2.dim = onTableDim( tables[ 1 ] );
  o2.colWidth = 9;
  o2.colSplits = 1;
  o2.style = 'doubleBorder';
  logger.log( _.strTable( o2 ).result );

  /* */

  function onTableDim( table )
  {
    debugger;
    return [ table.length, table[ 0 ][ _.mapKeys( table[ 0 ] )[ 0 ] ].length ];
  }

  /* */

  function onLength( src )
  {
    src = src.replace( /.+?m/mg, '' );
    return src.length;
  }

  /* */

  function onCellGet( i2d, o )
  {
    let row = o.data[ i2d[ 0 ] ];
    return row[ _.mapKeys( row )[ 0 ] ][ i2d[ 1 ] ];
  }

}

// //
//
// function drawTableOld()
// {
//   var Table = require( 'cli-table2' );
//   var tables = prepareTableInfo();
//   var o =
//   {
//     head : [ 'fg/bg' ],
//     colWidths : [ 9 ],
//     rowAligns : [ 'left' ],
//     colAligns : null,
//     style :
//     {
//       compact : true,
//     },
//   }
//
//   colorNames.forEach( ( name, i ) => colorNames[ i ] = shortColor( name ) );
//   o.head.push.apply( o.head, colorNames.slice( 0, colorNames.length / 2 ) );
//   o.colWidths.push.apply( o.colWidths, _.longFill( [], 6,         colorNames.length / 2 ) )
//   o.rowAligns.push.apply( o.rowAligns, _.longFill( [], 'center',  colorNames.length ) );
//   o.colAligns = o.rowAligns;
//
//   /**/
//
//   var table = new Table( o );
//   table.push.apply( table, tables[ 0 ] );
//   logger.log( table.toString() );
//
//   /**/
//
//   o.head = [ o.head[ 0 ] ];
//   o.head.push.apply( o.head, colorNames.slice( colorNames.length / 2, colorNames.length) );
//   var table = new Table( o );
//   table.push.apply( table, tables[ 1 ] );
//   logger.log( table.toString() );
// }
