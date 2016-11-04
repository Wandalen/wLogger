(function _PrinterBase_s_() {

'use strict';

if( typeof module !== 'undefined' )
{

  if( typeof wBase === 'undefined' )
  try
  {
    require( '../wTools.s' );
  }
  catch( err )
  {
    require( 'wTools' );
  }

}

//

var _ = wTools;
var Parent = null;
var Self = function wPrinterBase()
{
  if( !( this instanceof Self ) )
  if( o instanceof Self )
  return o;
  else
  return new( _.routineJoin( Self, Self, arguments ) );
  return Self.prototype.init.apply( this,arguments );
}

//

var init = function( o )
{
  var self = this;

  _.protoComplementInstance( self );

  if( o )
  self.copy( o );

  self.bindTo( null );

  Object.preventExtensions( self );

  // var self = _.mapExtend( this,o );
  // self.format = _.entityClone( self.format );

  return self;
}

//

var initClass = function()
{
  var proto = this;
  _.assert( Object.hasOwnProperty.call( proto,'constructor' ) );

  for( var m = 0 ; m < proto.methodsToBind.length ; m++ )
  if( !proto[ proto.methodsToBind[ m ] ] )
  proto._makeWrapForWriteMethodClass( methodsToBind[ m ] );

}

//

var bindTo = function( target,rewriting )
{
  var self = this;

  _.assert( arguments.length === 1 );
  _.assert( _.objectIs( target ) || target === null );

  for( var m = 0 ; m < self.methodsToBind.length ; m++ )
  {
    var name = self.methodsToBind[ m ];
    var nameAct = name + 'Act';

    if( !rewriting && _.routineIs( self[ nameAct ] ) )
    continue;

    if( target === null )
    {
      self[ nameAct ] = null;
      continue;
    }

    _.assert( target[ name ],'bindTo expects target has method',name );

    self[ nameAct ] = _.routineJoin( target,target[ name ] );

  }

}

//
// //
//
// var bindWriter = function( name,routine,context )
// {
//
//   /* */
//
//   var write = function()
//   {
//
//     var args = Array.prototype.slice.call( arguments,0 );
//
//     for( var a = 0 ; a < args.length ; a++ )
//     {
//       var arg = args[ a ];
//       if( !_.strIs( arg ) )
//       arg = _.toStr( arg );
//       args[ a ] = arg.split( '\n' ).join( '\n' + this.format.prefix.current );
//     }
//
//     if( args.length === 0 )
//     args = [ '' ];
//
//     args[ 0 ] = this.format.prefix.current + args[ 0 ];
//     args[ args.length-1 ] += this.format.postfix.current;
//
//     return context[ name ].apply( context,args );
//   }
//
//   /* */
//
//   var writeUp = function()
//   {
//
//     var result = this[ name ].apply( this,arguments );
//     this.up();
//     return result;
//
//   }
//
//   /* */
//
//   var writeDown = function()
//   {
//
//     this.down();
//     if( arguments.length )
//     var result = this[ name ].apply( this,arguments );
//     return result;
//
//   }
//
//   debugger;
//
//   this[ name ] = write;
//   this[ name + 'Up' ] = writeUp;
//   this[ name + 'Down' ] = writeDown;
//
// }

//

// var _makeJoinForWriteMethod = function( name,context,routine )
// {
//   var self = this;
//
//   _.assert( arguments.length === 2 );
//   _.assert( _.strIs( name ) );
//
//   self[ name + 'Act' ] =
//
// }

//var bindWrite = function( name,routine,context )
var _makeWrapForWriteMethodClass = function( name )
{
  var proto = this;

  _.assert( Object.hasOwnProperty.call( proto,'constructor' ) )
  _.assert( arguments.length === 1 );
  _.assert( _.strIs( name ) );

  var nameAct = name + 'Act';
  var nameUp = name + 'Up';
  var nameDown = name + 'Down';

  /* */

  var write = function()
  {

    //debugger;
    //var args = Array.prototype.slice.call( arguments );

    var args = this.writeDoing( arguments );

    // for( var a = 0 ; a < args.length ; a++ )
    // {
    //   var arg = args[ a ];
    //   if( !_.strIs( arg ) )
    //   arg = _.toStr( arg );
    //   args[ a ] = arg.split( '\n' ).join( '\n' + this.format.prefix.current );
    // }

    // if( args.length === 0 )
    // args = [ '' ];
    //
    // args[ 0 ] = this.format.prefix.current + args[ 0 ];
    // args[ args.length-1 ] += this.format.postfix.current;

    //return context[ name ].apply( context,args );

    // return this[ nameAct ]( args );

    _.assert( _.arrayIs( args ) );
    return this[ nameAct ].apply( this,args );
  }

  /* */

  var writeUp = function()
  {

    //console.log( nameUp );

    var result = this[ name ].apply( this,arguments );
    this.up();
    return result;

  }

  /* */

  var writeDown = function()
  {

    //console.log( nameDown );

    this.down();
    if( arguments.length )
    var result = this[ name ].apply( this,arguments );
    return result;

  }

  proto[ name ] = write;
  proto[ nameUp ] = writeUp;
  proto[ nameDown ] = writeDown;

}

//

var writeDoing = function( args )
{
  var self = this;

  _.assert( arguments.length === 1 );

  var result = [ _.str.apply( _,args ) ];

  return result;
}

//

var up = function( dLevel )
{
  var self = this;
  if( dLevel === undefined )
  dLevel = 1;

  //debugger;
  //console.log( 'up' );

  _.assert( arguments.length <= 1 );
  _.assert( isFinite( dLevel ) );

  self.levelSet( self.level + dLevel );

  // if( delta === undefined ) delta = 1;
  // for( var d = 0 ; d < delta ; d++ )
  // {
  //   var fix = this.format.prefix;
  //   if( _.strIs( fix.up ) ) fix.current += fix.up;
  //   else if( _.arrayIs( fix.up ) ) fix.current = fix.current.substring( fix.up[0],fix.current.length - fix.up[1] );
  //
  //   var fix = this.format.postfix;
  //   if( _.strIs( fix.up ) ) fix.current += fix.up;
  //   else if( _.arrayIs( fix.up ) ) fix.current = fix.current.substring( fix.up[0],fix.current.length - fix.up[1] );
  //
  //   this.format.level++;
  // }

}

//

var down = function( dLevel )
{
  var self = this;
  if( dLevel === undefined )
  dLevel = 1;

  //debugger;
  //console.log( 'down' );

  _.assert( arguments.length <= 1 );
  _.assert( isFinite( dLevel ) );

  self.levelSet( self.level - dLevel );

  // var self = this;
  // debugger;
  //
  // if( delta === undefined ) delta = 1;
  // for( var d = 0 ; d < delta ; d++ )
  // {
  //   this.format.level--;
  //
  //   var fix = this.format.prefix;
  //   if( _.strIs( fix.down ) )
  //   fix.current += fix.down;
  //   else if( _.arrayIs( fix.down ) )
  //   fix.current = fix.current.substring( fix.down[0],fix.current.length - fix.down[1] );
  //
  //   var fix = this.format.postfix;
  //   if( _.strIs( fix.down ) )
  //   fix.current += fix.down;
  //   else if( _.arrayIs( fix.down ) )
  //   fix.current = fix.current.substring( fix.down[0],fix.current.length - fix.down[1] );
  // }

}

//

// var levelGet = function()
// {
//   var self = this;
//   return self.format.level;
// }

//

var symbolForLevel = Symbol.for( 'level' );
var levelSet = function( level )
{
  var self = this;

  _.assert( level >= 0, 'levelSet : cant go below zero level to',level );
  _.assert( isFinite( level ) );

  self[ symbolForLevel ] = level;

  // self.format.level = level;
  // self.format.prefix.current = _.strTimes( self.format.prefix.up,level );
  // self.format.postfix.current = _.strTimes( self.format.postfix.up,level );

}

// --
// var
// --

// var format =
// {
//   level : 0,
//   prefix :
//   {
//     current : '',
//     up : '  ',
//     down : [ 2,0 ]
//   },
//   postfix :
//   {
//     current : '',
//     up : '',
//     down : ''
//   }
// }

// --
// relationships
// --

var Composes =
{
  level : 0,
}

var Aggregates =
{
}

var Associates =
{
}

var methodsToBind =
[
  'log',
  'error',
  'info',
  'warn',
];

// --
// prototype
// --

var Proto =
{

  // routine

  init : init,
  bindTo : bindTo,

  initClass : initClass,
  _makeWrapForWriteMethodClass : _makeWrapForWriteMethodClass,
  writeDoing : writeDoing,

  up : up,
  down : down,

  levelSet : levelSet,


  // var

  methodsToBind : methodsToBind,


  // relationships

  constructor : Self,
  Composes : Composes,
  Aggregates : Aggregates,
  Associates : Associates,

}

//

_.protoMake
({
  constructor : Self,
  parent : Parent,
  extend : Proto,
});

Self.prototype.initClass();

//

_.accessor
({
  object : Self.prototype,
  names :
  {
    level : 'level',
  }
});

//

_.accessorForbid
({
  object : Self.prototype,
  names :
  {
    format : 'format',
  }
});

// export

if( typeof module !== 'undefined' )
module[ 'exports' ] = Self;

_global_[ Self.name ] = wTools.PrinterBase = Self;

return Self;

})();
