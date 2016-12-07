## wLogger
Module in JavaScript providing convenient, layered, cross-platform means for multilevel, colorful logging.
Logger writes messages( incoming & outgoing ) to the specified output. By default it prints messages using console as output.
Supports colorful output in browser and shell, multilevel output, chaining with other console-like objects to perform message transfering between multiple inputs/outputs.


## Installation
```terminal
npm install wLogger
```
## Usage
### Options
* output { object }[ optional, default : console ] - single output object for current logger.
* level  { number }[ optional, default : 0 ] - controls current output level.

### Methods
Output:
* log
* error
* info
* warn

Leveling:
* Increase current output level - [up](https://rawgit.com/Wandalen/wLogger/master/doc/reference/wPrinterBase.html#.up)
* Decrease current output level - [down](https://rawgit.com/Wandalen/wLogger/master/doc/reference/wPrinterBase.html#.down)

Chaining:
* Add object to output list - [outputTo](https://rawgit.com/Wandalen/wLogger/master/doc/reference/wPrinterBase.html#.outputTo)
* Remove object from output list - [outputToUnchain](https://rawgit.com/Wandalen/wLogger/master/doc/reference/wPrinterBase.html#.outputToUnchain)
* Add current logger to target's output list - [inputFrom](https://rawgit.com/Wandalen/wLogger/master/doc/reference/wPrinterBase.html#.inputFrom)
* Remove current logger from target's output list - [inputFromUnchain](https://rawgit.com/Wandalen/wLogger/master/doc/reference/wPrinterBase.html#.inputFromUnchain)

Other:
* Check if object exists in logger's inputs list - [hasInput](https://rawgit.com/Wandalen/wLogger/master/doc/reference/wPrinterBase.html#.hasInput)
* Check if object exists in logger's outputs list - [hasOutput](https://rawgit.com/Wandalen/wLogger/master/doc/reference/wPrinterBase.html#.hasOutput)

##### Example #1
```javascript
/*Simple output*/
var l = new wLogger();
l.log( 'abc' );
```
##### Example #2
```javascript
/*Leveling*/
var l = new wLogger();
l.log('0 level')
/*Increase current level by 2*/
l.up( 2 );
l.log('2 level')
/*
0 level
    2 level
*/
```
##### Example #3
```javascript
/*Chaining*/
/*Disabling default output for l1*/
var l1 = new wLogger({ output : null });
var l2 = new wLogger();
/*Setting prefix for second logger*/
l2._prefix = 'l2_'
/*Setting second logger as output*/
l1.outputTo( l2 );
/*Each message from l1 will be transfered to l2*/
l1.log('message1')
l1.log('message2')
/*
l2_message1
l2_message2
*/
```
##### Example #4
```javascript
/*Simple colorful logging*/
var l = new wLogger();
/* prints message with red color,then sets foreground color to default */
l.log( '#foreground : red#text here#foreground : default#' );
/* prints message on yellow background,then sets background color to default */
l.log( '#background : yellow#text here#background : default#' );
```
##### Example #5
```javascript
/*Colorful logging using wTools.strColor*/
var l = new wLogger();
/* prints message with red color */
l.log( wTools.strColor.fg( 'message','red' ) );
/* prints message with yellow background */
l.log( wTools.strColor.bg( 'message','yellow' ) );
```
