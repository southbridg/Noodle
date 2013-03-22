/*
 * Examples  : Arduino Examples By....ETT CO.,LTD
 * Program   : MEGA2560_ADK_RS232
 * Hardware  : ET-MEGA2560-ADK(Arduino)
 * Function  : Switch UART[0,1,2,3] Interface
 */
#define H0 0xFF
#define H1 0xFE
#define ES0 0xFF
#define ES1 0xEF

//#define DEBUGMODE
#define PORT0DEST
#define PORT1SOURCE
#define PORT2DEST
#define PORT3DEST
#define COMPORT 0x01

byte ReadByte = 0;	// for incoming serial data

byte stateIO0=0;
byte IO0Occupied=0xFF;
byte target0=0;          // IO-0 state

byte stateIO1=0;
byte IO1Occupied=0xFF;
byte target1=0;          // IO-0 state

byte stateIO2=0;
byte IO2Occupied=0xFF;
byte target2=0;          // IO-0 state

byte stateIO3=0;
byte IO3Occupied=0xFF;
byte target3=0;         // IO-0 state

void setup() 
{ 
  Serial.begin(57600); 
  Serial.flush();
   Serial.print("");
   Serial.print("Debug[0] Ready\n");
#ifdef DEBUGMODE
  //Serial.print("UART0 Ready\n");
#endif
  Serial1.begin(57600); 
  Serial1.flush();
  Serial.print("");
  Serial1.print("Platform Ready\n");
#ifdef DEBUGMODE
 // Serial1.print("UART1 Ready\n");
#endif
  Serial2.begin(57600); 
  Serial2.flush();
#ifdef DEBUGMODE
  Serial2.print("UART2 Ready\n");
#endif
  Serial3.begin(57600); 
  Serial3.flush();
  Serial.print("");
#ifdef DEBUGMODE
  Serial3.print("UART3 Ready\n");
#endif 
} 

boolean occupied(byte sourceport,byte ioport){
  switch(ioport){
     case 0x00:{if(IO0Occupied!=0xFF && IO0Occupied!=sourceport)return false; else if(IO0Occupied==0xFF){IO0Occupied=sourceport; return true; } else return true; }break;
     case 0x01:{if(IO1Occupied!=0xFF && IO1Occupied!=sourceport)return false; else if(IO1Occupied==0xFF){IO1Occupied=sourceport; return true; } else return true; }break;
     case 0x02:{if(IO2Occupied!=0xFF && IO2Occupied!=sourceport)return false; else if(IO2Occupied==0xFF){IO2Occupied=sourceport; return true; } else return true; }break;
     case 0x03:{if(IO3Occupied!=0xFF && IO3Occupied!=sourceport)return false; else if(IO3Occupied==0xFF){IO3Occupied=sourceport; return true; } else return true; }break;
  }
}

void release(byte ioport){
    switch(ioport){
     case 0x00: IO0Occupied=0xFF; break;
     case 0x01: IO1Occupied=0xFF; break;
     case 0x02: IO2Occupied=0xFF; break;
     case 0x03: IO3Occupied=0xFF; break;
  }
}

void sendToIO(byte message,byte ioport){
     switch(ioport){
        case 0x0:Serial.print(message); break;
        case 0x1:Serial1.print(message); break;
        case 0x2:Serial2.print(message); break;
        case 0x3:Serial3.print(message); break;
     }  
}

void loop() 
{ 
     if (Serial.available() > 0){
          ReadByte = Serial.read();
#ifdef  PORT0DEST
          sendToIO(ReadByte,COMPORT);
#endif
#ifdef  PORT0SOURCE
          switch(stateIO0){
               case 0:{if(ReadByte==H0)stateIO0=1;} break;
               case 1:{if(ReadByte==H1)stateIO0=2;} break;
               case 2:{target0=ReadByte; stateIO0=3;} break;
               case 3:{
                        if(ReadByte==ES0)
                                stateIO0=4; 
                        else{ 
                               if(occupied(0x00,target0))
                                   sendToIO(ReadByte,target0); 
                        }
                      } break;
               case 4:{
                         if(ReadByte==ES1){
                               stateIO0=0;
                               if(occupied(0x00,target0))
                                   release(target0);
                         }else if(ReadByte==ES0){  
                               if(occupied(0x00,target0))
                                   sendToIO(ReadByte,target0); 
                         }else {  
                               if(occupied(0x00,target0)){
                                   sendToIO(ES0,target0); 
                                   sendToIO(ReadByte,target0);
                                } 
                                stateIO0=3;
                              }
                      } break;
          }
#endif
     }
    
     if(Serial1.available() > 0){
          ReadByte = Serial1.read();
#ifdef  PORT1DEST
          sendToIO(ReadByte,COMPORT);
#endif
#ifdef  PORT1SOURCE
          switch(stateIO1){
               case 0:{ if(ReadByte==H0) stateIO1=1; } break;
               case 1:{ if(ReadByte==H1) stateIO1=2; } break;
               case 2:{ target1=ReadByte; stateIO1=3;} break;
               case 3:{
                        if(ReadByte==ES0)
                                stateIO1=4; 
                        else{ 
                               if(occupied(0x01,target1))
                                   sendToIO(ReadByte,target1); 
                        }
                      } break;
               case 4:{
                         if(ReadByte==ES1){
                               stateIO1=0;
                               if(occupied(0x01,target1))
                                   release(target1);
                         }else if(ReadByte==ES0){  
                               if(occupied(0x01,target1))
                                   sendToIO(ReadByte,target1); 
                         }else {  
                               if(occupied(0x01,target1)){
                                   sendToIO(ES0,target1); 
                                   sendToIO(ReadByte,target1);
                                } 
                                stateIO1=3;
                              }
                      } break;
          }
#endif
     }
     
     if(Serial2.available() >0){
          ReadByte = Serial2.read();
#ifdef  PORT2DEST
          sendToIO(ReadByte,COMPORT);
#endif
#ifdef  PORT2SOURCE
          switch(stateIO2){
               case 0:{if(ReadByte==H0)stateIO2=1;} break;
               case 1:{if(ReadByte==H1)stateIO2=2;} break;
               case 2:{target2=ReadByte; stateIO2=3;} break;
               case 3:{
                        if(ReadByte==ES0)
                                stateIO2=4; 
                        else{ 
                               if(occupied(0x02,target2))
                                   sendToIO(ReadByte,target2); 
                        }
                      } break;
               case 4:{
                         if(ReadByte==ES1){
                               stateIO2=0;
                               if(occupied(0x02,target2))
                                   release(target2);
                         }else if(ReadByte==ES0){  
                               if(occupied(0x02,target2))
                                   sendToIO(ReadByte,target2); 
                         }else {  
                               if(occupied(0x02,target2)){
                                   sendToIO(ES0,target2); 
                                   sendToIO(ReadByte,target2);
                                } 
                                stateIO2=3;
                              }
                      } break;
          }
#endif
          
     }
     
     if(Serial3.available() >0){
          ReadByte = Serial3.read(); 
#ifdef  PORT3DEST
          sendToIO(ReadByte,COMPORT);
#endif 
#ifdef  PORT3SOURCE
          switch(stateIO3){
               case 0:{if(ReadByte==H0)stateIO3=1;} break;
               case 1:{if(ReadByte==H1)stateIO3=2;} break;
               case 2:{target3=ReadByte; stateIO3=3;} break;
               case 3:{
                        if(ReadByte==ES0)
                               stateIO3=4; 
                        else{ 
                               if(occupied(0x03,target3))
                                   sendToIO(ReadByte,target3); 
                        }
                      } break;
               case 4:{
                         if(ReadByte==ES1){
                               stateIO3=0;
                               if(occupied(0x03,target3))
                                   release(target3);
                         }else if(ReadByte==ES0){  
                               if(occupied(0x03,target3))
                                   sendToIO(ReadByte,target3); 
                         }else {  
                               if(occupied(0x03,target3)){
                                   sendToIO(ES0,target3); 
                                   sendToIO(ReadByte,target3);
                                } 
                                stateIO3=3;
                              }
                      } break;
          } 
#endif
     }
} 

