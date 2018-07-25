


if( typeof _global_ === 'undefined' || !_global_.wBase )
{
  let toolsPath = '../../../dwtools/Base.s';
  let toolsExternal = 0;
  try
  {
    toolsPath = require.resolve( toolsPath );
  }
  catch( err )
  {
    toolsExternal = 1;
    require( 'wTools' );
  }
  if( !toolsExternal )
  require( toolsPath );
}

var _global = _global_; var _ = _global_.wTools;

require( 'wConsequence' );
require( 'wLogger' );

var colorNames = _.mapOwnKeys( _.color.ColorMapShell );
colorNames = colorNames.slice( 0, colorNames.length / 2 );
colorNames.forEach( ( name ) => colorNames.push( 'light ' + name ) );

//

function shortColor( name )
{
  var parts = _.strSplitNonPreserving/**1**/({ src : name, preservingDelimeters : 0 });
  if( parts[ 0 ] === 'light' )
  name = 'l.' + parts[ 1 ];

  return name;
}

//

function prepareTableInfo()
{

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
    onTransformEnd : onTransformEnd
  })

  var c = 0;

  colorNames.forEach( ( fg ) =>
  {
    colorNames.forEach( ( bg ) =>
    {
      combinations.push({ fg : fg, bg : bg });
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

  function addLight( c )
  {
    if( !_.strBegins( c, 'light' ) )
    return 'light ' + c;
    return c;
  }

  _.Logger.illColorCombinations.forEach( ( c ) =>
  {
    remove( c.fg, c.bg );
    remove( c.bg, c.fg );
    remove( addLight( c.fg ), addLight( c.bg ) );
    remove( addLight( c.bg ), addLight( c.fg ) );
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
  var row;
  var i;

  var keys = _.mapOwnKeys( map );
  keys.forEach( ( fg ) =>
  {
    var c = map[ fg ];
    var obj1 = {};
    obj1[ fg ] = _.arrayFillTimes( [], colorNames.length / 2, '-' );
    row1 = obj1[ fg ];

    var obj2 = {};
    obj2[ fg ] = obj1[ fg ].slice();
    row2 = obj2[ fg ];

    c.forEach( ( bg ) =>
    {
      i = colorNames.indexOf( bg );
      var coloredLine = _.color.strFormatBackground( _.color.strFormatForeground( 'xYz', fg ), bg );
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
  var Table = require( 'cli-table2' );
  var tables = prepareTableInfo();
  var o =
  {
    head : [ "fg/bg" ],
    colWidths : [ 10 ],
    rowAligns : [ 'left' ],
    colAligns : null,
    style :
    {
       compact : true,
      'padding-left': 0,
      'padding-right': 0
    },
  }

  colorNames.forEach( ( name, i ) => colorNames[ i ] = shortColor( name ) );
  o.head.push.apply( o.head, colorNames.slice( 0, colorNames.length / 2 ) );
  o.colWidths.push.apply( o.colWidths, _.arrayFillTimes( [], colorNames.length / 2,  6 ) );
  o.rowAligns.push.apply( o.rowAligns, _.arrayFillTimes( [], colorNames.length / 2, 'center' ) );
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

_.shell( 'npm i cli-table2' )
.doThen( () => drawTable() )
