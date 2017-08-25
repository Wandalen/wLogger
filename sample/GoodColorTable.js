require( 'wTools' );
require( 'wConsequence' );
require( '../staging/abase/printer/printer/Logger.s' );

var _ = wTools;

var colorNames = _.mapOwnKeys( _.color.ColorMapShell );
colorNames = colorNames.slice( 0, colorNames.length / 2 );
colorNames.forEach( ( name ) => colorNames.push( 'light ' + name ) );

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
    row[ i ] =  data.outputForTerminal[ 0 ];
	}

  var combinations = [];
  var silencedLogger = new wLogger
  ({
    output : null,
    onWrite : onWrite
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

	wLogger.illColorCombinations.forEach( ( c ) =>
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

	var t = [];
	var row;
	var i;

	var keys = _.mapOwnKeys( map );
	keys.forEach( ( fg ) =>
	{
		var c = map[ fg ];
		var obj = {};
		obj[ fg ] = _.arrayFill({ times : colorNames.length, value : '-' });
		row = obj[ fg ];
		c.forEach( ( bg ) =>
		{
			i = colorNames.indexOf( bg );
			var coloredLine = _.strColor.bg( _.strColor.fg( 'xYz', fg ), bg );
			silencedLogger.log( coloredLine );
		});
		t.push( obj );
	})

	return t;
}


function drawTable()
{
  var Table = require( 'cli-table2' );
  var t = prepareTableInfo();
  var o =
  {
    head : [ "fg/bg" ],
    colWidths : [ 10 ],
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
  o.colWidths.push.apply( o.colWidths, _.arrayFill({ times : colorNames.length, value : 6 }) )
  o.rowAligns.push.apply( o.rowAligns, _.arrayFill({ times : colorNames.length, value : 'center' }) );
  o.colAligns = o.rowAligns;

  /**/

  var table = new Table( o );
  table.push.apply( table, t );
  logger.log( table.toString() );

  /**/

  // o.head = [ o.head[ 0 ] ];
  // o.head.push.apply( o.head, colorNames.slice( colorNames.length / 2, colorNames.length) );
  // var table = new Table( o );
  // table.push.apply( table, tables[ 1 ] );
  // logger.log( table.toString() );
}

_.shell( 'npm i cli-table2' )
.doThen( () => drawTable() )

