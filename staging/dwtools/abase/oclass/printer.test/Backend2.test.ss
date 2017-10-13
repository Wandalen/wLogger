( function _Backend2_test_s_( ) {

'use strict';

if( typeof module === 'undefined' )
return;

if( typeof module !== 'undefined' )
{
	try
	{
		require( '../../Base.s' );
	}
	catch( err )
	{
		require( 'wTools' );
	}

	var _ = wTools;


	_.include( 'wTesting' );

}

var _ = wTools;

// --
// resource
// --

function testFile()
{

	console.log( 'slave : starting' );
}

//

function onRoutineBegin( test,testFile )
{
	var self = this;
	var c = Object.create( null );

	c.tempDirPath = self.tempDirPath = _.pathRegularize( _.dirTempMake() );
	c.testFilePath = _.pathRegularize( _.pathJoin( c.tempDirPath,testFile.name + '.s' ) );

	_.fileProvider.fileWrite( c.testFilePath,_.routineSourceGet({ routine : testFile, withWrap : 0 }) );

	return c;
}

//

function onRoutineEnd( test )
{
	var self = this;
	_.fileProvider.filesDelete( self.tempDirPath );
}

// --
// test
// --

function trivial( test )
{
	var self = this;
	var c = onRoutineBegin.call( this,test,testFile );

	function onWrite( o )
	{
		got.push( o.input[ 0 ] );
	}
	var l = new wLogger({ onWrite : onWrite, output : null });

	var shell =
	{
		path : c.testFilePath,
		stdio : 'pipe',
		outputColoring : 0,
		outputPrefixing : 0,
		ipc : 1,
	}

	var expected =
	[
		'slave : starting',
	];

	var got  = [];

	var result = _.shellNode( shell )
	.doThen( function( err )
	{
		console.log( 'shellNode : done' );
		if( err )
		_.errLogOnce( err );
		test.description = 'no error from child process throwen';
		test.shouldBe( !err );
		test.shouldBe( _.arraySetIdentical( got, expected ) );
	});

	l.inputFrom( shell.process );

	return result;
}

trivial.timeOut = 30000;

// --
// proto
// --

var Self =
{

	name : 'Backend2',
	silencing : 1,

	onRoutineEnd : onRoutineEnd,

	context :
	{
		tempDirPath : null,
	},

	tests :
	{
		trivial : trivial,
	},

};

Self = wTestSuite( Self );
if( typeof module !== 'undefined' && !module.parent )
_.Tester.test( Self.name );

})();