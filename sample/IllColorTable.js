require( 'wTools' );
require( 'wConsequence' );
require( '../staging/abase/printer/printer/Logger.s' );

var _ = wTools;

// console.log( wLogger.illColorCombinations.length )

function prepareInfo()
{
  var list = [];
  var splitter = ' - ';

  function shortColor( name )
  {
	var parts = _.strSplit( name );
	if( parts[ 0 ] === 'light' )
	name = 'l.' + parts[ 1 ];

	return name;
  }

  function searchInList( src )
  {
  	for( var i = 0; i < list.length; i++ )
  	if( list[ i ][ src.fg + splitter + src.bg ] )
  	return list[ i ][ src.fg + splitter + src.bg ];
  }

  wLogger.illColorCombinations.forEach( function( c )
  {
	var res = searchInList( c );
	if( res )
	res.push( c.platform );
	else
	{
	  var newItem = {};
	  newItem[ c.fg + splitter + c.bg ] = [ c.platform ];
	  list.push( newItem );
	}
  })

  var row = _.arrayFill({ times : 3 , value : '-' });
  var currentPlatform;

  function onWrite( data )
  {
  	var rowMap =
  	{
  		'win32' : 0,
  		'darwin' : 1,
  		'linux' : 2,
  	}
  	row[ rowMap[ currentPlatform ] ]= data.outputForTerminal[ 0 ];
  }
  var silencedLogger = new wLogger
  ({
  	output : null,
  	onWrite : onWrite
  })

	var result = [];

	var splitCombinationKey = ( src ) => _.mapOwnKeys( src )[ 0 ].split( splitter );

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
  	var key = _.mapOwnKeys( c )[ 0 ];
  	var combination = key.split( splitter );
  	var fg = combination[ 0 ];
  	var bg = combination[ 1 ];
  	for( var i = 0; i < c[ key ].length; i++ )
  	{
  	  currentPlatform = c[ key ][ i ];
  	  silencedLogger.log( _.strColor.bg( _.strColor.fg( 'Ill combination', fg ) ,bg ));
	}
	var newRow = {};
	var fg = shortColor( combination[ 0 ] );
	var bg = shortColor( combination[ 1 ] );
	newRow[ fg + splitter + bg ] = row;
  addToTable( newRow );
	row = _.arrayFill({ times : 3 , value : '-' });
	})


  return result;
}

function drawTable()
{
  var Table = require( 'cli-table2' );
  var info = prepareInfo();
  var o =
  {
  	head : [ "fg - bg", 'win32', 'darwin', 'linux' ],
  	colWidths : [ 19 ],
  	rowAligns : [ 'left', 'center', 'center', 'center' ],
  	colAligns : [ 'center', 'center', 'center', 'center' ],
  	style:
  	{
  	 compact : true,
  	 'padding-left': 0,
  	 'padding-right': 0
  	},
  }

  /**/

  var table = new Table( o );
  table.push.apply( table, info );
  logger.log( table.toString() );
}

_.shell( 'npm i cli-table2' )
.doThen( () => drawTable() );




