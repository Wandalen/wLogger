(function _aColoredMixin_s_() {

'use strict';

var isBrowser = true;
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

  isBrowser = false;

  var _ = wTools;

  try
  {
    _.include( 'wColor' );
  }
  catch( err )
  {
  }

}

var _ = wTools;

//

function mixin( constructor )
{

  var dst = constructor.prototype;

  _.assert( arguments.length === 1 );
  _.assert( _.routineIs( constructor ) );

  _.mixin
  ({
    dst : dst,
    mixin : Self,
  });

  _.accessor
  ({
    object : dst,
    combining : 'rewrite',
    names :
    {
      // level : 'level',
      foregroundColor : 'foregroundColor',
      backgroundColor : 'backgroundColor',
    }
  });

}

// --
// etc
// --

function _rgbToCode( rgb, add )
{
  var r = rgb[ 0 ];
  var g = rgb[ 1 ];
  var b = rgb[ 2 ];

  var lightness = _.color.rgbToHsl( rgb )[ 2 ];

  var ansi = 30 + ( ( Math.round( b ) << 2 ) | ( Math.round( g ) << 1 ) | Math.round( r ) );

  // why 8 ???

  if( add )
  ansi = ansi + add;

  if( lightness === .25  )
  ansi = '1;' + ansi;

  return ansi;
}

//

function _handleStrip( strip )
{
  var allowedKeys = [ 'bg','background','fg','foreground', 'coloring', 'trackingColor' ];
  var parts = strip.split( ' : ' );
  if( parts.length === 2 )
  {
    if( allowedKeys.indexOf( parts[ 0 ] ) === -1 )
    return;
    return parts;
  }
}

//

function _foregroundColorGet()
{
  var self = this;
  return self[ symbolForForeground ];
}

//

function _backgroundColorGet()
{
  var self = this;
  return self[ symbolForBackground ];
}

//

function _setColor( color, layer )
{
  var self = this;

  var symbol;

  if( layer === 'foreground' )
  symbol = symbolForForeground;

  if( layer === 'background' )
  symbol = symbolForBackground;

  _.assert( _.symbolIs( symbol ) );

  if( !_.color )
  {
    color = null;
  }

  if( color && color !== 'default' )
  {
    color = _.color.rgbaFromTry( color, null );
    if( color )
    {
      if( isBrowser )
      color = _.color.colorNearestCustom({ color : color, colorMap : _.color.ColorMap });
      else
      color = _.color.colorNearestCustom({ color : color, colorMap : _.color.ColorMapShell });
    }
  }

  if( !color || color === 'default' )
  {
    if( self._stackIsNotEmpty( layer ) )
    self[ symbol ] = self._stackPop( layer );
    else
    self[ symbol ] = null;
  }
  else
  {
    if( self[ symbol ] )
    self._stackPush( layer, self[ symbol ] );

    self[ symbol ] = color;
    self._isStyled = 1;
  }
}

//

function _foregroundColorSet( color )
{
  var self = this;
  var layer = 'foreground';

  self._setColor( color, layer );
}

//

function _backgroundColorSet( color )
{
  var self = this;
  var layer = 'background';

  self._setColor( color, layer );
}

// --
// stack
// --

function _stackPush( layer, color )
{
  var self = this;

  if( !self.colorsStack )
  {
    self.colorsStack = { 'foreground' : [], 'background' : [] };
  }

  self.colorsStack[ layer ].push( color );
}

//

function _stackPop( layer )
{
  var self = this;

  return self.colorsStack[ layer ].pop();
}

//

function _stackIsNotEmpty( layer )
{
  var self = this;
  if( self.colorsStack && self.colorsStack[ layer ].length )
  return true;

  return false;
}

// --
// colored text
// --

/* !!! find a new home for the function */

function coloredToHtml( o )
{
  var self = this;

  _.assert( arguments.length === 1 );

  if( !_.objectIs( o ) )
  o = { src : o }

  _.routineOptions( coloredToHtml,o );
  _.assert( _.strIs( o.src ) || _.arrayIs( o.src ) );
  _.assert( _.routineIs( o.onStrip ) );

  if( _.arrayIs( o.src ) )
  {
    var optionsForStr =
    {
      delimeter  : ''
    }
    o.src = _.strConcat.apply( optionsForStr ,o.src );

  }

  var result = '';
  var spanCount = 0;

  var splitted = _.strExtractStrips( o.src, { onStrip : o.onStrip } );

  for( var i = 0; i < splitted.length; i++ )
  {
    if( _.arrayIs( splitted[ i ] ) )
    {
      var style = splitted[ i ][ 0 ];
      var color = splitted[ i ][ 1 ];

      if( color && color !== 'default' )
      {
        var color = _.color.rgbaFromTry( color, null );
        if( color )
        color = _.color.colorNearestCustom({ color : color, colorMap : _.color.ColorMap })
      }

      if( style === 'foreground')
      {
        self.foregroundColor = color;
      }
      else if( style === 'background')
      {
        self.backgroundColor = color;
      }

      var fg = self.foregroundColor;
      var bg = self.backgroundColor;

      if( !fg || fg === 'default' )
      fg = null;

      if( !bg || bg === 'default' )
      bg = null;

      if( color === 'default' && spanCount )
      {
        result += `</${o.tag}>`;
        spanCount--;
      }
      else
      {
        var style = '';

        if( o.compact )
        {
          if( fg )
          style += `color:${ _.color.colorToRgbaHtml( fg ) };`;

          if( bg )
          style += `background:${ _.color.colorToRgbaHtml( bg ) };`;
        }
        else
        {
          fg = fg || 'transparent';
          bg = bg || 'transparent';
          style = `color:${ _.color.colorToRgbaHtml( fg ) };background:${ _.color.colorToRgbaHtml( bg ) };`;
        }

        if( style.length )
        result += `<${o.tag} style='${style}'>`;
        else
        result += `<${o.tag}>`;

        spanCount++;
      }
    }
    else
    {
      var text = _.strReplaceAll( splitted[ i ], '\n', '<br>' );

      if( !o.compact && !spanCount )
      {
        result += `<${o.tag}>${text}</${o.tag}>`;
      }
      else
      result += text;
    }
  }

  _.assert( spanCount === 0 );

  return result;
}

coloredToHtml.defaults =
{
  src : null,
  tag : 'span',
  compact : true,
  onStrip : _handleStrip,
}

//

function _writePrepareHtml( o )
{
  var self = this;

  _.assert( arguments.length === 1 );
  _.assert( _.mapIs( o ) );
  _.assert( _.strIs( o.output[ 0 ] ) );
  _.assert( o.output.length === 1 );

  o.outputForTerminal = [ self.coloredToHtml( o.output[ 0 ] ) ];

  return o;
}

//

// function _writePrepareShell( o )
// {
//   var self = this;
//
//   _.assert( arguments.length === 1 );
//   _.assert( _.mapIs( o ) );
//   _.assert( _.strIs( o.output[ 0 ] ) );
//
//   var result = '';
//
//   var splitted = _.strExtractStrips( o.output[ 0 ], { onStrip : self._handleStrip } );
//   var layersOnly = true;
//   for( var i = 0; i < splitted.length; i++ )
//   {
//     if( _.strIs( splitted[ i ] ) )
//     {
//       layersOnly = false;
//
//       if( self._cursorSaved )
//       {
//         /*restores cursos position*/
//         result +=  '\x1b[u';
//         self._cursorSaved = 0;
//       }
//       result +=  splitted[ i ];
//     }
//     else
//     {
//       var layer = splitted[ i ][ 0 ];
//       var color = splitted[ i ][ 1 ];
//
//       if( layer === 'foreground')
//       {
//         self.foregroundColor = color;
//
//         if( self.foregroundColor )
//         result += `\x1b[${ self._rgbToCode( self.foregroundColor ) }m`;
//         else
//         result += `\x1b[39m`;
//       }
//       else if( layer === 'background' )
//       {
//         self.backgroundColor = color;
//
//         if( self.backgroundColor )
//         result += `\x1b[${ self._rgbToCode( self.backgroundColor ) + 10 }m`;
//         else
//         result += `\x1b[49m`;
//       }
//     }
//   }
//
//   if( layersOnly )
//   {
//     /* saves cursos position */
//     self._cursorSaved = 1;
//     result += '\x1b[s';
//   }
//
//   o.outputForTerminal = [ result ];
//
//   return o;
// }

//

function _handleDirective( directive )
{
  var self = this;

  var name = directive[ 0 ];
  var value = directive[ 1 ];

  if( self.trackingColor )
  {
    if( name === 'foreground' )
    {
      self.foregroundColor = value;
    }
    if( name === 'background' )
    {
      self.backgroundColor = value;
    }
  }

  if( name === 'coloring' )
  {
    self.usingColorFromStack = _.boolFrom( value );
  }
  if( name === 'trackingColor' )
  {
    self.trackingColor = _.boolFrom( value );
  }
}

//

function _writePrepareShell( o )
{
  var self = this;

  _.assert( arguments.length === 1 );
  _.assert( _.mapIs( o ) );
  _.assert( _.strIs( o.output[ 0 ] ) );

  var result = '';

  var splitted = _.strExtractStrips( o.output[ 0 ], { onStrip : self._handleStrip } );
  var layersOnly = true;

  splitted.forEach( function ( strip )
  {
    if( _.arrayIs( strip ) )
    {
      self._handleDirective( strip );
    }

    if( _.strIs( strip ) )
    {
      layersOnly = false;

      if( self.usingColorFromStack )
      {
        if( self.foregroundColor )
        result += `\x1b[${ self._rgbToCode( self.foregroundColor ) }m`;

        if( self.backgroundColor )
        result += `\x1b[${ self._rgbToCode( self.backgroundColor, 10 ) }m`;
      }

      result += strip;

      if( self.usingColorFromStack )
      {
        if( self.foregroundColor )
        result += `\x1b[39m`;
        if( self.backgroundColor )
        result += `\x1b[49m`;
      }
    }
  })

  // if( layersOnly && splitted.length )
  // o.outputForTerminal = [];
  // else
  o.outputForTerminal = [ result ];

  return o;
}

//

function _writePrepareBrowser( o )
{
  var self = this;

  _.assert( arguments.length === 1 );
  _.assert( _.mapIs( o ) );
  _.assert( _.strIs( o.output[ 0 ] ) );

  var result = [ '' ];

  var splitted = _.strExtractStrips( o.output[ 0 ], { onStrip : self._handleStrip } );
  if( splitted.length === 1 && !self._isStyled )
  {
    if( !_.arrayIs( splitted[ 0 ] ) )
    return splitted;
  }

  for( var i = 0; i < splitted.length; i++ )
  {
    if( _.arrayIs( splitted[ i ] ) )
    {
      self._handleDirective( splitted[ i ] );

      if( !self.foregroundColor && !self.backgroundColor )
      self._isStyled = 0;
      else if( !!self.foregroundColor | !!self.backgroundColor )
      self._isStyled = 1;
    }
    else
    {
      if( ( !i && !self._isStyled ) || !self.usingColorFromStack )
      {
        result[ 0 ] += splitted[ i ];
      }
      else
      {
        var fg = self.foregroundColor || 'none';
        var bg = self.backgroundColor || 'none';

        result[ 0 ] += `%c${ splitted[ i ] }`;
        result.push( `color:${ _.color.colorToRgbaHtml( fg ) };background:${ _.color.colorToRgbaHtml( bg ) };` );
      }
    }
  }

  o.outputForTerminal = result;

  return o;
}

//

function _writePrepareWithoutColors( o )
{
  var self = this;
  var result = '';

  _.assert( arguments.length === 1 );
  _.assert( _.mapIs( o ) );
  _.assert( _.strIs( o.output[ 0 ] ) );

  var splitted = _.strExtractStrips( o.output[ 0 ], { onStrip : self._handleStrip } );
  for( var i = 0 ; i < splitted.length ; i++ )
  {
    if( _.strIs( splitted[ i ] ) )
    result += splitted[ i ];
  }

  o.outputForTerminal = [ result ];

  return o;
}

//

function _writePrepare( original )
{

  return function _writePrepare( o )
  {
    var self = this;

    _.assert( arguments.length === 1 );
    _.assert( _.mapIs( o ) );

    o = original.call( self,o );

    _.assert( _.strIs( o.pure ) );
    _.assert( _.arrayLike( o.input ) );
    _.assert( _.arrayLike( o.output ) );
    _.assert( o.output.length === 1 )

    if( _.color && self.coloring )
    {

      if( self.permanentStyle )
      {
        o.output[ 0 ] = _.strColor.style( o.output[ 0 ],self.permanentStyle );
      }

      if( self.coloringConnotation )
      {
        if( self.attributes.connotation === 'positive' )
        o.output[ 0 ] = _.strColor.style( o.output[ 0 ],'positive' );
        else if( self.attributes.connotation === 'negative' )
        o.output[ 0 ] = _.strColor.style( o.output[ 0 ],'negative' );
      }

      if( self.coloringHeadAndTail )
      if( self.attributes.head || self.attributes.tail )
      if( _.strStrip( o.pure ) )
      {
        var reserve = self.verbosityReserve();
        if( self.attributes.head && reserve > 1 )
        o.output[ 0 ] = _.strColor.style( o.output[ 0 ],'head' );
        else if( self.attributes.tail && reserve > 1 )
        o.output[ 0 ] = _.strColor.style( o.output[ 0 ],'tail' );
      }

      if( !self.passingRawColor )
      {
        if( self.writingToHtml )
        self._writePrepareHtml( o );
        else if( !isBrowser )
        self._writePrepareShell( o );
        else
        self._writePrepareBrowser( o );
      }

    }
    else
    {
      self._writePrepareWithoutColors( o );
    }

    _.assert( _.arrayIs( o.output ) );

    return o;
  }

}

// --
// topic
// --

function topic()
{
  var self = this;

  // debugger;

  // var result = self._strConcat( arguments );
  var result = _.strConcat.apply( undefined,arguments );

  result = _.strColor.bg( result,'white' );

  this.log();
  this.log( result );
  this.log();

  return result;
}

//

function topicUp()
{
  var self = this;

  // var result = self._strConcat( arguments );
  var result = _.strConcat.apply( undefined,arguments );

  result = _.strColor.bg( result,'white' );

  this.log();
  this.logUp( result );
  this.log();

  return result;
}

//

function topicDown()
{
  var self = this;

  // var result = self._strConcat( arguments );
  var result = _.strConcat.apply( undefined,arguments );

  result = _.strColor.bg( result,'white' );


  this.log();
  this.logDown( result );
  this.log();

  return result;
}

// --
// relationships
// --

var symbolForLevel = Symbol.for( 'level' );
var symbolForForeground = Symbol.for( 'foregroundColor' );
var symbolForBackground = Symbol.for( 'backgroundColor' );

var Composes =
{

  foregroundColor : null,
  backgroundColor : null,

  colorsStack : null,
  passingRawColor : 0,
  coloring : 1,
  coloringHeadAndTail : 1,
  coloringConnotation : 1,
  writingToHtml : 0,

  _isStyled : 0,
  _cursorSaved : 0,
  usingColorFromStack : 1,
  trackingColor : 1,


  permanentStyle : null,

  // attributes : {},

}

var Aggregates =
{

}

var Associates =
{

}

var Statics =
{
  coloredToHtml : coloredToHtml
}

// --
// proto
// --

var Functor =
{

  _writePrepare : _writePrepare,

}

var Extend =
{

  // etc

  _rgbToCode : _rgbToCode,
  _handleStrip : _handleStrip,

  _foregroundColorGet : _foregroundColorGet,
  _backgroundColorGet : _backgroundColorGet,

  _setColor : _setColor,
  _foregroundColorSet : _foregroundColorSet,
  _backgroundColorSet : _backgroundColorSet,

  _handleDirective : _handleDirective,

  // stack

  _stackPush : _stackPush,
  _stackPop : _stackPop,
  _stackIsNotEmpty : _stackIsNotEmpty,


  // colored text

  coloredToHtml : coloredToHtml,
  _writePrepareHtml : _writePrepareHtml,
  _writePrepareShell : _writePrepareShell,
  _writePrepareBrowser : _writePrepareBrowser,
  _writePrepareWithoutColors : _writePrepareWithoutColors,


  // topic

  topic : topic,
  topicUp : topicUp,
  topicDown : topicDown,


  // relationships

  Composes : Composes,
  Aggregates : Aggregates,
  Associates : Associates,
  Statics : Statics,

}

//

var Self =
{

  Extend : Extend,
  Functor : Functor,

  mixin : mixin,

  name : 'wPrinterColoredMixin',
  nameShort : 'PrinterColoredMixin',

}

// export

if( typeof module !== 'undefined' )
module[ 'exports' ] = Self;

_global_[ Self.name ] = wTools[ Self.nameShort ] = Self;

return Self;

})();
