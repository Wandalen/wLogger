
try
{
  require( '../../../../node_modules/Tools' );
}
catch( err )
{
  require( 'wTools' );
}

const _ = _global_.wTools

_.include( 'wConsequence' );
_.include( 'wLogger' );

drawTable();

//

function prepareInfo()
{
  var list = [];
  var splitter = ' - ';

  logger.diagnosingColor = 0;

  function shortColor( name )
  {
    var parts = _.strSplitNonPreserving({ src : name, preservingDelimeters : 0 });

    if( parts[ 0 ] === 'dark' )
    name = 'd.' + parts[ 1 ];

    if( parts[ 0 ] === 'bright' )
    name = 'b.' + parts[ 1 ];

    return name;
  }

  function searchInList( src )
  {
    for( var i = 0; i < list.length; i++ )
    if( list[ i ][ src.fg + splitter + src.bg ] )
    return list[ i ][ src.fg + splitter + src.bg ];
  }

  let platform = process.platform;

  debugger;
  _.Logger.PoisonedColorCombination.forEach( function( c )
  {
    if( c.platform !== platform )
    return;
    var res = searchInList( c );
    if( res )
    res.push( c.platform );
    else
    {
      var newItem = {};
      newItem[ c.fg + splitter + c.bg ] = [ c.platform ];
      list.push( newItem );
    }
  });
  debugger;

  var row = _.longFill( [], '-', 3 );
  var currentPlatform;

  function onTransformEnd( data )
  {
    var rowMap =
    {
      'win32' : 0,
      'darwin' : 1,
      'linux' : 2,
    }
    row[ rowMap[ currentPlatform ] ]= data.output;
  }
  var silencedLogger = new _.Logger
  ({
    output : null,
    onTransformEnd,
  })

  var result = [];

  var splitCombinationKey = ( src ) => _.mapOnlyOwnKeys( src )[ 0 ].split( splitter );

  function addToTable( src )
  {
    var pos = 0;
    var srcColors = splitCombinationKey( src );
    for( var i = 0; i < result.length; i++ )
    {
      var currentColors = splitCombinationKey( result[ i ] );
      if( srcColors[ 0 ] === currentColors[ 0 ]  )
      {
        pos = i;
      }
    }

    if( !pos )
    result.push( src )
    else
    result.splice( pos, 0, src );
  }

  list.forEach( function( c )
  {
    var key = _.mapOnlyOwnKeys( c )[ 0 ];
    var combination = key.split( splitter );
    var fg = combination[ 0 ];
    var bg = combination[ 1 ];
    for( var i = 0; i < c[ key ].length; i++ )
    {
      currentPlatform = c[ key ][ i ];
      silencedLogger.log( _.ct.bg( _.ct.fg( 'TEXT TEXT TEXT', fg ), bg ));
    }
    var newRow = {};
    var fg = shortColor( combination[ 0 ] );
    var bg = shortColor( combination[ 1 ] );
    newRow[ fg + splitter + bg ] = row;
    addToTable( newRow );
    row = _.longFill( [], '-', 3 );
  })


  return result;
}

//

function drawTable()
{
  var info = prepareInfo();
  var o2 = Object.create( null );
  o2.topHead = [ 'fg/bg', 'win32', 'darwin', 'linux' ];
  o2.leftHead = [ 'fg/bg', ... leftHeadFrom( info ) ];
  o2.onCellGet = onCellGet;
  o2.onLength = onLength;
  o2.data = info;
  o2.dim = onTableDim( info );
  o2.colSplits = 1;
  /* o2.rowSplits = 1; */
  o2.style = 'doubleBorder';
  logger.log( _.strTable( o2 ).result );

  /* */

  function leftHeadFrom( table )
  {
    return table.map( ( e ) => wTools.mapKeys( e )[ 0 ] );
  }

  /* */

  function onTableDim( table )
  {
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

//
//
// function drawTableOld()
// {
//   var Table = require( 'cli-table2' );
//   var info = prepareInfo();
//   var o =
//   {
//     head : [ "fg - bg", 'win32', 'darwin', 'linux' ],
//     colWidths : [ 22 ],
//     rowAligns : [ 'left', 'center', 'center', 'center' ],
//     colAligns : [ 'center', 'center', 'center', 'center' ],
//     style:
//     {
//      compact : false,
//      'padding-left': 0,
//      'padding-right': 0
//     },
//   }
//
//   /**/
//
//   var table = new Table( o );
//   table.push.apply( table, info );
//   logger.log( table.toString() );
// }
//
//
