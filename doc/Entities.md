## Entities

## Low level ( Parent = null ) :

### Class _.LoggerBasic
Class with basic abilities of the printer: input transformation, verbosity level change.

### Class _.Chainer
Class that encapsulates chainability of printers, loggers and consoles.

### Class _.PrinterChainingMixin
Class that extends printer with mechanism of message transfering between multiple inputs/outputs.

### Class _.PrinterColoredMixin
Class that extends printer with mechanism of message coloring.

## Middle level :

### Class _.LoggerMid
Class that extends logger with input transforming, attributing and verbosity control mechanics. Parent : _.LoggerBasic

## Upper level :

### Class _.Logger
Class that creates a logger for printing colorful and well formatted diagnostic code. Parent : _.LoggerMid.

### Class _.LoggerPrime
Parent : _.Logger

### Class _.PrinterToLayeredHtml
Class that creates a printer that writes messages into a DOM container. Parent : _.Logger.

### Class _.LoggerToString
Class that creates a printer that collects messages into a single string. Parent : _.LoggerMid.

