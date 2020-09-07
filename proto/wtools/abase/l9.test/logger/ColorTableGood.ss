
try
{
  require( '../../../../wtools/Tools.s' );
}
catch( err )
{
  require( 'wTools' );
}

let _global = _global_;
let _ = _global_.wTools;

_.include( 'wLogger' );

let colorNames =
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
  logger.diagnosingColor = 0;

  function onTransformEnd( data )
  {
    if( i < colorNames.length / 2 )
    row1[ i ] =  data.outputForTerminal[ 0 ];
    else
    row2[ i - colorNames.length / 2 ] =  data.outputForTerminal[ 0 ];
  }

  var combinations = [];
  var silencedLogger = new _.Logger
  ({
    output : null,
    onTransformEnd
  })

  var c = 0;

  colorNames.forEach( ( fg ) =>
  {
    colorNames.forEach( ( bg ) =>
    {
      combinations.push({ fg, bg });
    })
  })

  function remove( fg, bg )
  {
    for( var i = 0; i < combinations.length; i++ )
    {
      var c = combinations[ i ];
      if( c.fg === fg && c.bg === bg )
      return combinations.splice( i, 1 );
    }
  }

  let platform = process.platform;

  _.Logger.PoisonedColorCombination.forEach( ( c ) =>
  {
    if( c.platform !== platform )
    return;

    remove( c.fg, c.bg );
    remove( c.bg, c.fg );
  })

  var map = {};

  combinations.forEach( ( c ) =>
  {
    if( !map[ c.fg ] )
    map[ c.fg ] = [];

    if( c.fg !== c.bg )
    map[ c.fg ].push( c.bg );
  });

  var t1 = [];
  var t2 = [];
  var row1  = {};
  var row2  = {};
  var row, i;

  var keys = _.mapOwnKeys( map );
  keys.forEach( ( fg ) =>
  {
    var c = map[ fg ];
    var obj1 = {};
    obj1[ fg ] = _.longFill( [], '-', colorNames.length / 2 );
    row1 = obj1[ fg ];

    var obj2 = {};
    obj2[ fg ] = obj1[ fg ].slice();
    row2 = obj2[ fg ];

    c.forEach( ( bg ) =>
    {
      i = colorNames.indexOf( bg );
      var coloredLine = _.ct.bg( _.ct.fg( 'xYz', fg ), bg );
      silencedLogger.log( coloredLine );
    });

    t1.push( obj1 );
    t2.push( obj2 );
  })

  return [ t1, t2 ];
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
//     head : [ "fg/bg" ],
//     colWidths : [ 10 ],
//     rowAligns : [ 'left' ],
//     colAligns : null,
//     style :
//     {
//        compact : true,
//       'padding-left': 0,
//       'padding-right': 0
//     },
//   }
//
//   colorNames.forEach( ( name, i ) => colorNames[ i ] = shortColor( name ) );
//   o.head.push.apply( o.head, colorNames.slice( 0, colorNames.length / 2 ) );
//   debugger;
//   o.colWidths.push.apply( o.colWidths, _.longFill( [], 8, colorNames.length / 2 ) );
//   o.rowAligns.push.apply( o.rowAligns, _.longFill( [], 'center', colorNames.length / 2 ) );
//   // o.colWidths.push.apply( o.colWidths, _.longFillTimes( [], colorNames.length / 2,  8 ) );
//   // o.rowAligns.push.apply( o.rowAligns, _.longFillTimes( [], colorNames.length / 2, 'center' ) );
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
