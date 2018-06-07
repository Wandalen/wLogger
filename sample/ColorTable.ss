


if( typeof _global_ === 'undefined' || !_global_.wBase )
{
  let toolsPath = '../../../../dwtools/Base.s';
  let toolsExternal = 0;
  try
  {
    toolsPath = require.resolve( toolsPath );/*hhh*/
  }
  catch( err )
  {
    toolsExternal = 1;
    require( 'wTools' );
  }
  if( !toolsExternal )
  require( toolsPath );
}

var _ = _global_.wTools

_.include( 'wConsequence' );
_.include( 'wLogger' );

// require( '../staging/dwtools/abase/printer/top/Logger.s' );

var colorNames = _.mapOwnKeys( _.color.ColorMapShell );
colorNames = colorNames.slice( 0, colorNames.length / 2 );
colorNames.forEach( ( name ) => colorNames.push( 'light ' + name ) );

//

function shortColor( name )
{
  var parts = _.strSplit( name );
  if( parts[ 0 ] === 'light' )
  name = 'l.' + parts[ 1 ];

  return name;
}

//

function prepareTableInfo()
{
  function onWrite( data )
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
    onWrite : onWrite
  })
  for( var i = 0; i < colorNames.length; i++ )
  {
    fg = colorNames[ i ];
    row1[ shortColor( fg ) ] = [];
    row2[ shortColor( fg ) ] = [];
    for( var j = 0; j < colorNames.length; j++ )
    {
      c++;
      bg = colorNames[ j ];
      var coloredLine = _.color.strFormatBackground( _.color.strFormatForeground( 'xYz', fg ), bg );
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
  o.colWidths.push.apply( o.colWidths, _.arrayFillTimes( [] , colorNames.length / 2 , 6 ) )
  o.rowAligns.push.apply( o.rowAligns, _.arrayFillTimes( [] , colorNames.length , 'center' ) );
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
.doThen( () => drawTable() );
