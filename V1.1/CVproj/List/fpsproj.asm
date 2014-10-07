
;CodeVisionAVR C Compiler V2.05.3 Standard
;(C) Copyright 1998-2011 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATmega8L
;Program type             : Application
;Clock frequency          : 8.000000 MHz
;Memory model             : Small
;Optimize for             : Size
;(s)printf features       : int, width
;(s)scanf features        : int, width
;External RAM size        : 0
;Data Stack size          : 256 byte(s)
;Heap size                : 0 byte(s)
;Promote 'char' to 'int'  : Yes
;'char' is unsigned       : Yes
;8 bit enums              : Yes
;Global 'const' stored in FLASH     : No
;Enhanced function parameter passing: Yes
;Enhanced core instructions         : On
;Smart register allocation          : On
;Automatic register allocation      : On

	#pragma AVRPART ADMIN PART_NAME ATmega8L
	#pragma AVRPART MEMORY PROG_FLASH 8192
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1119
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x045F
	.EQU __DSTACK_SIZE=0x0100
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	RCALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMRDW
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X
	.ENDM

	.MACRO __GETD1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X+
	LD   R22,X
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	RCALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _menuOpt=R5
	.DEF _refreshMenu=R4
	.DEF _adc_data=R6
	.DEF _rx_wr_index=R9
	.DEF _rx_rd_index=R8
	.DEF _tx_wr_index=R11
	.DEF _tx_rd_index=R10
	.DEF _tx_counter=R13
	.DEF __lcd_x=R12

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	RJMP __RESET
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP _timer0_ovf_isr
	RJMP 0x00
	RJMP _usart_rx_isr
	RJMP 0x00
	RJMP _usart_tx_isr
	RJMP _adc_isr
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00

_fingerPrint_charTable:
	.DB  0x4E,0x51,0x55,0x54,0x57,0x50,0x4F,0xC0
_power_charTable:
	.DB  0x42,0x44,0x48,0x4E,0x42,0x44,0x48,0xC0
_battery_charTable:
	.DB  0x4E,0x51,0x51,0x5F,0x5F,0x5F,0x5F,0xC0
_switch_charTable:
	.DB  0x42,0x49,0x46,0x41,0x46,0x48,0x44,0xC0
_locked_charTable:
	.DB  0x4E,0x51,0x51,0x5F,0x5B,0x5B,0x5F,0xC0
_unlocked_charTable:
	.DB  0x4E,0x50,0x50,0x5E,0x5B,0x5B,0x5F,0xC0
_smilie_charTable:
	.DB  0x40,0x4A,0x40,0x40,0x51,0x4E,0x40,0xC0
_tbl10_G100:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G100:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

;REGISTER BIT VARIABLES INITIALIZATION
__REG_BIT_VARS:
	.DW  0x0000

_0xB6:
	.DB  0x1,0xFF
_0x0:
	.DB  0x4B,0x69,0x6E,0x64,0x6C,0x79,0x20,0x47
	.DB  0x69,0x76,0x65,0x20,0x79,0x6F,0x75,0x72
	.DB  0x0,0x61,0x75,0x74,0x68,0x65,0x6E,0x74
	.DB  0x69,0x63,0x61,0x74,0x69,0x6F,0x6E,0x0
	.DB  0x50,0x6C,0x61,0x63,0x65,0x20,0x74,0x68
	.DB  0x65,0x20,0x66,0x69,0x6E,0x67,0x65,0x72
	.DB  0x0,0x54,0x68,0x61,0x6E,0x6B,0x20,0x79
	.DB  0x6F,0x75,0x3A,0x20,0x0,0x41,0x63,0x63
	.DB  0x65,0x73,0x73,0x20,0x64,0x65,0x6E,0x69
	.DB  0x65,0x64,0x3A,0x20,0x0,0x4D,0x65,0x6D
	.DB  0x6F,0x72,0x79,0x20,0x46,0x75,0x6C,0x6C
	.DB  0x21,0x0,0x44,0x65,0x6C,0x65,0x74,0x65
	.DB  0x20,0x61,0x6E,0x20,0x49,0x44,0x0,0x49
	.DB  0x44,0x20,0x61,0x76,0x61,0x69,0x6C,0x61
	.DB  0x62,0x6C,0x65,0x3A,0x20,0x0,0x52,0x65
	.DB  0x6D,0x61,0x69,0x6E,0x69,0x6E,0x67,0x3A
	.DB  0x20,0x0,0x66,0x61,0x69,0x6C,0x65,0x64
	.DB  0x2E,0x0,0x53,0x75,0x63,0x63,0x65,0x65
	.DB  0x64,0x65,0x64,0x0,0x53,0x61,0x76,0x65
	.DB  0x64,0x20,0x61,0x74,0x3A,0x20,0x0,0x50
	.DB  0x6C,0x61,0x63,0x65,0x20,0x74,0x68,0x65
	.DB  0x0,0x55,0x6E,0x6B,0x6E,0x6F,0x77,0x6E
	.DB  0x20,0x49,0x44,0x0,0x45,0x52,0x52,0x4F
	.DB  0x52,0x0,0x43,0x6F,0x6E,0x66,0x69,0x72
	.DB  0x6D,0x3F,0x0,0x44,0x65,0x6C,0x65,0x74
	.DB  0x65,0x64,0x0,0x3E,0x20,0x4D,0x65,0x6E
	.DB  0x75,0x0,0x53,0x65,0x63,0x75,0x72,0x69
	.DB  0x74,0x79,0x3A,0x0,0x22,0x47,0x6F,0x20
	.DB  0x53,0x6D,0x61,0x72,0x74,0x22,0x0,0x22
	.DB  0x4F,0x70,0x65,0x6E,0x20,0x66,0x6F,0x72
	.DB  0x20,0x61,0x6C,0x6C,0x22,0x0,0x22,0x4C
	.DB  0x6F,0x63,0x6B,0x20,0x74,0x68,0x65,0x20
	.DB  0x44,0x6F,0x6F,0x72,0x22,0x0,0x52,0x65
	.DB  0x67,0x65,0x69,0x73,0x74,0x65,0x72,0x20
	.DB  0x61,0x6E,0x20,0x49,0x44,0x0,0x44,0x65
	.DB  0x6C,0x65,0x74,0x65,0x20,0x61,0x6C,0x6C
	.DB  0x20,0x49,0x44,0x73,0x0,0x53,0x79,0x73
	.DB  0x74,0x65,0x6D,0x20,0x53,0x74,0x61,0x74
	.DB  0x75,0x73,0x0,0x50,0x72,0x65,0x73,0x73
	.DB  0x20,0x22,0x53,0x65,0x6C,0x65,0x63,0x74
	.DB  0x22,0x0,0x49,0x44,0x73,0x20,0x63,0x6F
	.DB  0x75,0x6E,0x74,0x3A,0x20,0x0,0x56,0x6F
	.DB  0x6C,0x74,0x61,0x67,0x65,0x3A,0x20,0x0
	.DB  0x56,0x0,0x46,0x50,0x53,0x20,0x63,0x6F
	.DB  0x75,0x6E,0x74,0x3A,0x0
_0x60000:
	.DB  0x74,0x65,0x63,0x68,0x43,0x52,0x45,0x41
	.DB  0x54,0x49,0x4F,0x4E,0x53,0x0
_0x80003:
	.DB  0x55,0xAA,0x1
_0x80000:
	.DB  0x46,0x61,0x69,0x6C,0x65,0x64,0x0,0x50
	.DB  0x6C,0x61,0x63,0x65,0x20,0x66,0x69,0x6E
	.DB  0x67,0x65,0x72,0x20,0x0,0x28,0x31,0x2F
	.DB  0x33,0x29,0x0,0x46,0x61,0x69,0x6C,0x65
	.DB  0x64,0x2E,0x20,0x0,0x52,0x65,0x73,0x65
	.DB  0x74,0x69,0x6E,0x67,0x20,0x46,0x50,0x53
	.DB  0x2E,0x0,0x54,0x61,0x6B,0x65,0x20,0x6F
	.DB  0x66,0x20,0x74,0x68,0x65,0x20,0x0,0x66
	.DB  0x69,0x6E,0x67,0x65,0x72,0x2E,0x0,0x28
	.DB  0x32,0x2F,0x33,0x29,0x0,0x46,0x61,0x69
	.DB  0x6C,0x65,0x64,0x2E,0x20,0x52,0x65,0x73
	.DB  0x65,0x74,0x69,0x6E,0x67,0x20,0x0,0x28
	.DB  0x33,0x2F,0x33,0x29,0x0,0x45,0x6E,0x72
	.DB  0x6F,0x6C,0x6C,0x6D,0x65,0x6E,0x74,0x20
	.DB  0x0
_0x2020003:
	.DB  0x80,0xC0
_0x2040060:
	.DB  0x1
_0x2040000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  0x02
	.DW  __REG_BIT_VARS*2

	.DW  0x02
	.DW  0x04
	.DW  _0xB6*2

	.DW  0x03
	.DW  _txPacket
	.DW  _0x80003*2

	.DW  0x02
	.DW  __base_y_G101
	.DW  _0x2020003*2

	.DW  0x01
	.DW  __seed_G102
	.DW  _0x2040060*2

_0xFFFFFFFF:
	.DW  0

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

;DISABLE WATCHDOG
	LDI  R31,0x18
	OUT  WDTCR,R31
	OUT  WDTCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	RJMP _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x160

	.CSEG
;#include <mega8.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;#include <delay.h>
;#include <stdio.h>
;#include "projHeaders.h"
;#include "projDefines.h"
;#include "FPS_GT511Cx.h"
;#include "GPS_GT511x_comDefs.h"
;#include "customCharsCG.h"
;
;// Alphanumeric LCD functions
;#include <alcd.h>
;// Declare your global variables here
;eeprom char securityMethod;
;eeprom char failedCount;
;
;//not tested
;unsigned char askAuthentication(void)
; 0000 0012 {

	.CSEG
_askAuthentication:
; 0000 0013     unsigned char i = 20;
; 0000 0014     lcd_clear();
	ST   -Y,R17
;	i -> R17
	LDI  R17,20
	RCALL _lcd_clear
; 0000 0015     lcd_putsf("Kindly Give your");
	__POINTW2FN _0x0,0
	RCALL SUBOPT_0x0
; 0000 0016     lcd_gotoxy(0,1);
; 0000 0017     lcd_putsf("authentication");
	__POINTW2FN _0x0,17
	RCALL SUBOPT_0x1
; 0000 0018     delay_ms(1000);
; 0000 0019     i = getIdFinally(3, 0);
	RCALL SUBOPT_0x2
; 0000 001A     return  ((i < 8) || (i == 10));
	BRLO _0x3
	CPI  R17,10
	BREQ _0x3
	LDI  R30,0
	RJMP _0x4
_0x3:
	LDI  R30,1
_0x4:
	RJMP _0x20C000A
; 0000 001B }
;//not tested
;unsigned char getIdFinally(unsigned char retries, unsigned char isForDoor)
; 0000 001E {
_getIdFinally:
; 0000 001F     unsigned char i = 0, id = 10, j = 0;
; 0000 0020     bip();
	ST   -Y,R26
	RCALL __SAVELOCR4
;	retries -> Y+5
;	isForDoor -> Y+4
;	i -> R17
;	id -> R16
;	j -> R19
	LDI  R17,0
	LDI  R16,10
	LDI  R19,0
	RCALL _bip
; 0000 0021     if (!isForDoor)
	RCALL SUBOPT_0x3
	BRNE _0x5
; 0000 0022     {
; 0000 0023         lcd_clear();
	RCALL _lcd_clear
; 0000 0024         lcd_putsf("Place the finger");
	__POINTW2FN _0x0,32
	RCALL _lcd_putsf
; 0000 0025         //delay_ms(2000);
; 0000 0026     }
; 0000 0027 
; 0000 0028     FPS_power be ON;
_0x5:
	RCALL SUBOPT_0x4
; 0000 0029     FPS_open();
; 0000 002A     for (i = 0; i < retries; i++)
	LDI  R17,LOW(0)
_0x9:
	LDD  R30,Y+5
	CP   R17,R30
	BRLO PC+2
	RJMP _0xA
; 0000 002B     {
; 0000 002C         autoSleepTimer = 0;
	LDI  R30,LOW(0)
	STS  _autoSleepTimer,R30
; 0000 002D         if (failedCount >= 5 && junkFreeTimer < 60)
	RCALL SUBOPT_0x5
	BRLO _0xC
	LDS  R26,_junkFreeTimer
	CPI  R26,LOW(0x3C)
	BRLO _0xD
_0xC:
	RJMP _0xB
_0xD:
; 0000 002E         {
; 0000 002F             FPS_power be OFF;
	CBI  0x12,2
; 0000 0030             lcd_clear();
	RCALL _lcd_clear
; 0000 0031             soundAlarm();
	RCALL _soundAlarm
; 0000 0032             return 11;
	LDI  R30,LOW(11)
	RJMP _0x20C000E
; 0000 0033         }
; 0000 0034         else if (failedCount >= 5)
_0xB:
	RCALL SUBOPT_0x5
	BRLO _0x11
; 0000 0035         {
; 0000 0036             failedCount = 0;
	RCALL SUBOPT_0x6
; 0000 0037         }
; 0000 0038 
; 0000 0039         setCmosLED(1);
_0x11:
	RCALL SUBOPT_0x7
; 0000 003A         while (!fingerPressed())
_0x12:
	RCALL SUBOPT_0x8
	BRNE _0x14
; 0000 003B         {
; 0000 003C             if (cancel_PB is pressed || autoSleepTimer > 5)
	RCALL SUBOPT_0x9
	BREQ _0x16
	LDS  R26,_autoSleepTimer
	CPI  R26,LOW(0x6)
	BRLO _0x15
_0x16:
; 0000 003D             {
; 0000 003E                 FPS_power be OFF;
	CBI  0x12,2
; 0000 003F                 return 9;
	LDI  R30,LOW(9)
	RJMP _0x20C000E
; 0000 0040             }
; 0000 0041         }
_0x15:
	RJMP _0x12
_0x14:
; 0000 0042         setCmosLED(1);
	RCALL SUBOPT_0x7
; 0000 0043         //delay_ms(250);
; 0000 0044         for (j = 0; j < 10 ; j++)
	LDI  R19,LOW(0)
_0x1B:
	CPI  R19,10
	BRSH _0x1C
; 0000 0045         {
; 0000 0046             id = getFingerId();
	RCALL _getFingerId
	MOV  R16,R30
; 0000 0047             if (id < 8)
	CPI  R16,8
	BRSH _0x1D
; 0000 0048             {
; 0000 0049                 j = 10;
	LDI  R19,LOW(10)
; 0000 004A             }
; 0000 004B             else
_0x1D:
; 0000 004C             {
; 0000 004D                 //delay_ms(100);
; 0000 004E             }
; 0000 004F         }
	SUBI R19,-1
	RJMP _0x1B
_0x1C:
; 0000 0050         if (id < 8)
	CPI  R16,8
	BRSH _0x1F
; 0000 0051         {
; 0000 0052             FPS_power be OFF;
	CBI  0x12,2
; 0000 0053             failedCount = 0;
	RCALL SUBOPT_0x6
; 0000 0054 
; 0000 0055             if (!isForDoor)
	RCALL SUBOPT_0x3
	BRNE _0x22
; 0000 0056             {
; 0000 0057                 if (!isForDoor)
	RCALL SUBOPT_0x3
	BRNE _0x23
; 0000 0058                 {
; 0000 0059                     lcd_clear();
	RCALL _lcd_clear
; 0000 005A                     lcd_putsf("Thank you: ");
	__POINTW2FN _0x0,49
	RCALL SUBOPT_0xA
; 0000 005B 
; 0000 005C                     lcd_putchar('0' + id);
; 0000 005D                 }
; 0000 005E                 soundOK();
_0x23:
	RCALL _soundOK
; 0000 005F                 delay_ms(1000);
	RCALL SUBOPT_0xB
; 0000 0060             }
; 0000 0061             else
	RJMP _0x24
_0x22:
; 0000 0062             bip();
	RCALL _bip
; 0000 0063 
; 0000 0064             return id;
_0x24:
	MOV  R30,R16
	RJMP _0x20C000E
; 0000 0065         }
; 0000 0066         else
_0x1F:
; 0000 0067         {
; 0000 0068             if (!isForDoor)
	RCALL SUBOPT_0x3
	BRNE _0x26
; 0000 0069             {
; 0000 006A                 lcd_clear();
	RCALL _lcd_clear
; 0000 006B                 lcd_putsf("Access denied: ");
	__POINTW2FN _0x0,61
	RCALL SUBOPT_0xA
; 0000 006C 
; 0000 006D                 lcd_putchar('0' + id);
; 0000 006E             }
; 0000 006F             failedCount ++;
_0x26:
	LDI  R26,LOW(_failedCount)
	LDI  R27,HIGH(_failedCount)
	RCALL SUBOPT_0xC
; 0000 0070             if (failedCount >=5)
	RCALL SUBOPT_0x5
	BRLO _0x27
; 0000 0071                 junkFreeTimer = 0;
	LDI  R30,LOW(0)
	STS  _junkFreeTimer,R30
; 0000 0072         }
_0x27:
; 0000 0073         soundError();
	RCALL _soundError
; 0000 0074     }
	SUBI R17,-1
	RJMP _0x9
_0xA:
; 0000 0075     return 12;
	LDI  R30,LOW(12)
_0x20C000E:
	RCALL __LOADLOCR4
	ADIW R28,6
	RET
; 0000 0076 }
;
;//not tested
;unsigned int registerID(void)
; 0000 007A {
_registerID:
; 0000 007B     char i = 0, j = 0, k = 0;
; 0000 007C     lcd_clear();
	RCALL __SAVELOCR4
;	i -> R17
;	j -> R16
;	k -> R19
	LDI  R17,0
	LDI  R16,0
	LDI  R19,0
	RCALL _lcd_clear
; 0000 007D     FPS_power be ON;
	RCALL SUBOPT_0x4
; 0000 007E     FPS_open();
; 0000 007F     i = getEnrolledCount();
	RCALL _getEnrolledCount
	MOV  R17,R30
; 0000 0080     if (i >= 8)
	CPI  R17,8
	BRLO _0x2A
; 0000 0081     {
; 0000 0082         FPS_power be OFF;
	CBI  0x12,2
; 0000 0083         lcd_putsf("Memory Full!");
	__POINTW2FN _0x0,77
	RCALL SUBOPT_0x0
; 0000 0084         lcd_gotoxy(0,1);
; 0000 0085         lcd_putsf("Delete an ID");
	__POINTW2FN _0x0,90
	RCALL SUBOPT_0xD
; 0000 0086         delay_ms(2000);
; 0000 0087         return 10;
	RCALL SUBOPT_0xE
	RCALL __LOADLOCR4
	RJMP _0x20C000B
; 0000 0088     }
; 0000 0089     i = getAFreeId();
_0x2A:
	RCALL _getAFreeId
	MOV  R17,R30
; 0000 008A     j = getEnrolledCount();
	RCALL _getEnrolledCount
	MOV  R16,R30
; 0000 008B     lcd_clear();
	RCALL _lcd_clear
; 0000 008C     lcd_putsf("ID available: ");
	__POINTW2FN _0x0,103
	RCALL SUBOPT_0xF
; 0000 008D     lcd_putchar('0' + i);
; 0000 008E     lcd_gotoxy(0,1);
; 0000 008F     lcd_putsf("Remaining: ");
; 0000 0090     lcd_putchar(8 - j + '0');
	SUB  R30,R16
	RCALL SUBOPT_0x10
; 0000 0091     delay_ms(2000);
; 0000 0092     i = enrollAFinger(i);
	MOV  R26,R17
	RCALL _enrollAFinger
	MOV  R17,R30
; 0000 0093     while (cancel_PB is pressed);
_0x2D:
	SBIS 0x10,5
	RJMP _0x2D
; 0000 0094     if (i == 2)
	CPI  R17,2
	BRNE _0x30
; 0000 0095     {
; 0000 0096         soundCancel();
	RCALL _soundCancel
; 0000 0097     }
; 0000 0098     else
	RJMP _0x31
_0x30:
; 0000 0099     {
; 0000 009A         k = getEnrolledCount();
	RCALL _getEnrolledCount
	MOV  R19,R30
; 0000 009B         if (j == k) // failed
	CP   R19,R16
	BRNE _0x32
; 0000 009C         {
; 0000 009D             lcd_putsf("failed.");
	__POINTW2FN _0x0,130
	RCALL _lcd_putsf
; 0000 009E             soundError();
	RCALL _soundError
; 0000 009F         }
; 0000 00A0         else
	RJMP _0x33
_0x32:
; 0000 00A1         {
; 0000 00A2             lcd_putsf("Succeeded");
	__POINTW2FN _0x0,138
	RCALL _lcd_putsf
; 0000 00A3         }
_0x33:
; 0000 00A4         delay_ms(1000);
	RCALL SUBOPT_0xB
; 0000 00A5         lcd_clear();
	RCALL _lcd_clear
; 0000 00A6         lcd_putsf("Saved at: ");
	__POINTW2FN _0x0,148
	RCALL SUBOPT_0xF
; 0000 00A7         lcd_putchar(i + '0');
; 0000 00A8         lcd_gotoxy(0,1);
; 0000 00A9         lcd_putsf("Remaining: ");
; 0000 00AA         lcd_putchar(8 - k + '0');
	SUB  R30,R19
	RCALL SUBOPT_0x10
; 0000 00AB         delay_ms(2000);
; 0000 00AC 
; 0000 00AD     }
_0x31:
; 0000 00AE     FPS_power be OFF;
	CBI  0x12,2
; 0000 00AF     return i;
	MOV  R30,R17
	RCALL SUBOPT_0x11
	RCALL __LOADLOCR4
	RJMP _0x20C000B
; 0000 00B0 }
;//not tested
;void deleteIdByFinger(unsigned char all)
; 0000 00B3 {
_deleteIdByFinger:
; 0000 00B4     char i = 0;
; 0000 00B5     lcd_clear();
	ST   -Y,R26
	ST   -Y,R17
;	all -> Y+1
;	i -> R17
	LDI  R17,0
	RCALL _lcd_clear
; 0000 00B6     lcd_putsf("Place the");
	__POINTW2FN _0x0,159
	RCALL SUBOPT_0x0
; 0000 00B7     lcd_gotoxy(0,1);
; 0000 00B8     lcd_putsf("finger");
	__POINTW2FN _0x0,42
	RCALL _lcd_putsf
; 0000 00B9     i = getIdFinally(3, 0);
	RCALL SUBOPT_0x2
; 0000 00BA     if (i == 8)
	BRNE _0x36
; 0000 00BB     {
; 0000 00BC         soundError();
	RCALL _soundError
; 0000 00BD         lcd_putsf("Unknown ID");
	__POINTW2FN _0x0,169
	RCALL SUBOPT_0xD
; 0000 00BE         delay_ms(2000);
; 0000 00BF         return;
	LDD  R17,Y+0
	RJMP _0x20C0002
; 0000 00C0     }
; 0000 00C1     else if (i > 8)
_0x36:
	CPI  R17,9
	BRLO _0x38
; 0000 00C2     {
; 0000 00C3         soundError();
	RCALL _soundError
; 0000 00C4         lcd_putsf("ERROR");
	__POINTW2FN _0x0,180
	RCALL SUBOPT_0xD
; 0000 00C5         delay_ms(2000);
; 0000 00C6         return;
	LDD  R17,Y+0
	RJMP _0x20C0002
; 0000 00C7     }
; 0000 00C8 
; 0000 00C9     while(options_PB is pressed or cancel_PB is pressed or select_PB is pressed);
_0x38:
_0x39:
	RCALL SUBOPT_0x12
	BREQ _0x3C
	RCALL SUBOPT_0x9
	BREQ _0x3C
	LDI  R26,0
	SBIC 0x10,6
	LDI  R26,1
	CPI  R26,LOW(0x0)
	BRNE _0x3B
_0x3C:
	RJMP _0x39
_0x3B:
; 0000 00CA 
; 0000 00CB     lcd_clear();
	RCALL _lcd_clear
; 0000 00CC     lcd_putsf("Confirm?");
	__POINTW2FN _0x0,186
	RCALL _lcd_putsf
; 0000 00CD     soundQuestion();
	RCALL _soundQuestion
; 0000 00CE     while(options_PB is unpressed and cancel_PB is unpressed and select_PB is unpressed);
_0x3E:
	SBIS 0x10,7
	RJMP _0x41
	SBIS 0x10,5
	RJMP _0x41
	SBIC 0x10,6
	RJMP _0x42
_0x41:
	RJMP _0x40
_0x42:
	RJMP _0x3E
_0x40:
; 0000 00CF     if (select_PB is pressed)
	SBIC 0x10,6
	RJMP _0x43
; 0000 00D0     {
; 0000 00D1         FPS_power be ON;
	RCALL SUBOPT_0x4
; 0000 00D2         FPS_open();
; 0000 00D3 
; 0000 00D4         if(all)
	LDD  R30,Y+1
	CPI  R30,0
	BREQ _0x46
; 0000 00D5         {
; 0000 00D6             for(all = 0; all < 8; all++)
	RCALL SUBOPT_0x13
_0x48:
	LDD  R26,Y+1
	CPI  R26,LOW(0x8)
	BRSH _0x49
; 0000 00D7             {
; 0000 00D8                 if (all != i)
	CP   R17,R26
	BREQ _0x4A
; 0000 00D9                     deleteID(all);
	RCALL _deleteID
; 0000 00DA             }
_0x4A:
	LDD  R30,Y+1
	SUBI R30,-LOW(1)
	STD  Y+1,R30
	RJMP _0x48
_0x49:
; 0000 00DB         }
; 0000 00DC         else
	RJMP _0x4B
_0x46:
; 0000 00DD             deleteID(i);
	MOV  R26,R17
	RCALL _deleteID
; 0000 00DE         FPS_power be OFF;
_0x4B:
	CBI  0x12,2
; 0000 00DF         lcd_clear();
	RCALL _lcd_clear
; 0000 00E0         lcd_putsf("Deleted");
	__POINTW2FN _0x0,195
	RCALL _lcd_putsf
; 0000 00E1         soundSuccess();
	RCALL _soundSuccess
; 0000 00E2         delay_ms(1000);
	RCALL SUBOPT_0xB
; 0000 00E3     }
; 0000 00E4     else
	RJMP _0x4E
_0x43:
; 0000 00E5     {
; 0000 00E6         soundCancel();
	RCALL _soundCancel
; 0000 00E7     }
_0x4E:
; 0000 00E8 }
	LDD  R17,Y+0
	RJMP _0x20C0002
;signed char menuOpt = -1, refreshMenu = 1;
;void main(void)
; 0000 00EB {
_main:
; 0000 00EC     char i = 0, notSpace = 15, alreadyFresh = 0;;
; 0000 00ED     //Init Block
; 0000 00EE     {
;	i -> R17
;	notSpace -> R16
;	alreadyFresh -> R19
	LDI  R17,0
	LDI  R16,15
	LDI  R19,0
; 0000 00EF         controller_init();
	RCALL _controller_init
; 0000 00F0 
; 0000 00F1         if (resetByWDT == 1)
; 0000 00F2         {
; 0000 00F3             resetByWDT = 0;
; 0000 00F4             goto resumeSession;
; 0000 00F5         }
; 0000 00F6         resetByWDT = 0;
_0xB2:
	LDI  R26,LOW(_resetByWDT)
	LDI  R27,HIGH(_resetByWDT)
	LDI  R30,LOW(0)
	RCALL __EEPROMWRB
; 0000 00F7 
; 0000 00F8     }
; 0000 00F9 
; 0000 00FA     resumeSession:
; 0000 00FB 
; 0000 00FC     failedCount = 0;
	RCALL SUBOPT_0x6
; 0000 00FD 
; 0000 00FE     while(1)
_0x51:
; 0000 00FF     {
; 0000 0100         if (lockMotor is ON || FPS_power is ON)
	SBIC 0x18,7
	RJMP _0x55
	SBIS 0x12,2
	RJMP _0x54
_0x55:
; 0000 0101         {
; 0000 0102             controllerReset();
	RCALL _controllerReset
; 0000 0103         }
; 0000 0104 
; 0000 0105         if (elapsed_sec % 10 == 0 && menuOpt == -1 && !alreadyFresh)
_0x54:
	RCALL SUBOPT_0x14
	RCALL SUBOPT_0x15
	SBIW R30,0
	BRNE _0x58
	LDI  R30,LOW(255)
	CP   R30,R5
	BRNE _0x58
	CPI  R19,0
	BREQ _0x59
_0x58:
	RJMP _0x57
_0x59:
; 0000 0106         {
; 0000 0107             refreshMenu = 1;
	RCALL SUBOPT_0x16
; 0000 0108             alreadyFresh = 1;
	LDI  R19,LOW(1)
; 0000 0109         }
; 0000 010A         else
	RJMP _0x5A
_0x57:
; 0000 010B         {
; 0000 010C             alreadyFresh = 0;
	LDI  R19,LOW(0)
; 0000 010D         }
_0x5A:
; 0000 010E         if (refreshMenu)
	TST  R4
	BRNE PC+2
	RJMP _0x5B
; 0000 010F         {
; 0000 0110             notSpace = 15;
	LDI  R16,LOW(15)
; 0000 0111             refreshMenu = 0;
	CLR  R4
; 0000 0112             lcd_clear();
	RCALL _lcd_clear
; 0000 0113             switch (menuOpt)
	RCALL SUBOPT_0x17
; 0000 0114             {
; 0000 0115                 case -1: //no menu
	CPI  R30,LOW(0xFFFFFFFF)
	LDI  R26,HIGH(0xFFFFFFFF)
	CPC  R31,R26
	BRNE _0x5F
; 0000 0116                     lcd_gotoxy(10,0);
	LDI  R30,LOW(10)
	ST   -Y,R30
	RCALL SUBOPT_0x18
; 0000 0117                     if (mV < 4500)
	RCALL SUBOPT_0x19
	CPI  R26,LOW(0x1194)
	LDI  R30,HIGH(0x1194)
	CPC  R27,R30
	BRGE _0x60
; 0000 0118                     {
; 0000 0119                         lcd_gotoxy(notSpace, 0);
	RCALL SUBOPT_0x1A
; 0000 011A                         notSpace --;
	SUBI R16,1
; 0000 011B                         lcd_putchar(2);
	LDI  R26,LOW(2)
	RCALL _lcd_putchar
; 0000 011C                     }
; 0000 011D                     if (mV > 4300)
_0x60:
	RCALL SUBOPT_0x1B
	BRLT _0x61
; 0000 011E                     {
; 0000 011F                         lcd_gotoxy(notSpace, 0);
	RCALL SUBOPT_0x1A
; 0000 0120                         notSpace --;
	SUBI R16,1
; 0000 0121                         lcd_putchar(3);
	LDI  R26,LOW(3)
	RCALL _lcd_putchar
; 0000 0122                     }
; 0000 0123                     lcd_gotoxy(notSpace, 0);
_0x61:
	RCALL SUBOPT_0x1A
; 0000 0124                     notSpace --;
	SUBI R16,1
; 0000 0125                     if (securityMethod == 1)
	RCALL SUBOPT_0x1C
	CPI  R30,LOW(0x1)
	BRNE _0x62
; 0000 0126                     {
; 0000 0127                         lcd_putchar(6);
	LDI  R26,LOW(6)
	RJMP _0xB3
; 0000 0128                     }
; 0000 0129                     else if (securityMethod == 2)
_0x62:
	RCALL SUBOPT_0x1C
	CPI  R30,LOW(0x2)
	BRNE _0x64
; 0000 012A                     {
; 0000 012B                         lcd_putchar(5);
	LDI  R26,LOW(5)
	RJMP _0xB3
; 0000 012C                     }
; 0000 012D                     else
_0x64:
; 0000 012E                     {
; 0000 012F                         lcd_putchar(4);
	LDI  R26,LOW(4)
_0xB3:
	RCALL _lcd_putchar
; 0000 0130                     }
; 0000 0131 
; 0000 0132                     lcd_gotoxy(0,1);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(1)
	RCALL _lcd_gotoxy
; 0000 0133                     lcd_putsf("> Menu");
	__POINTW2FN _0x0,203
	RCALL _lcd_putsf
; 0000 0134                 break;
	RJMP _0x5E
; 0000 0135 
; 0000 0136                 case 0:
_0x5F:
	SBIW R30,0
	BRNE _0x66
; 0000 0137                     lcd_putsf("Security:");
	__POINTW2FN _0x0,210
	RCALL SUBOPT_0x0
; 0000 0138                     lcd_gotoxy(0,1);
; 0000 0139                     if (securityMethod == 1)
	RCALL SUBOPT_0x1C
	CPI  R30,LOW(0x1)
	BRNE _0x67
; 0000 013A                         lcd_putsf("\"Go Smart\"");
	__POINTW2FN _0x0,220
	RJMP _0xB4
; 0000 013B                     else if (securityMethod == 2)
_0x67:
	RCALL SUBOPT_0x1C
	CPI  R30,LOW(0x2)
	BRNE _0x69
; 0000 013C                         lcd_putsf("\"Open for all\"");
	__POINTW2FN _0x0,231
	RJMP _0xB4
; 0000 013D                     else
_0x69:
; 0000 013E                         lcd_putsf("\"Lock the Door\"");
	__POINTW2FN _0x0,246
_0xB4:
	RCALL _lcd_putsf
; 0000 013F                 break;
	RJMP _0x5E
; 0000 0140 
; 0000 0141                 case 1:
_0x66:
	RCALL SUBOPT_0x1D
	BRNE _0x6B
; 0000 0142                     lcd_putsf("Regeister an ID");
	__POINTW2FN _0x0,262
	RCALL _lcd_putsf
; 0000 0143                 break;
	RJMP _0x5E
; 0000 0144 
; 0000 0145                 case 2:
_0x6B:
	RCALL SUBOPT_0x1E
	BRNE _0x6C
; 0000 0146                     lcd_putsf("Delete an ID");
	__POINTW2FN _0x0,90
	RCALL _lcd_putsf
; 0000 0147                 break;
	RJMP _0x5E
; 0000 0148                 case 3:
_0x6C:
	RCALL SUBOPT_0x1F
	BRNE _0x6D
; 0000 0149                     lcd_putsf("Delete all IDs");
	__POINTW2FN _0x0,278
	RCALL _lcd_putsf
; 0000 014A                 break;
	RJMP _0x5E
; 0000 014B                 case 4:
_0x6D:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BREQ PC+2
	RJMP _0x5E
; 0000 014C                     switch(i % 4)
	RCALL SUBOPT_0x20
; 0000 014D                     {
; 0000 014E                         case 0:
	SBIW R30,0
	BRNE _0x72
; 0000 014F                             lcd_putsf("System Status");
	__POINTW2FN _0x0,293
	RCALL SUBOPT_0x0
; 0000 0150                             lcd_gotoxy(0,1);
; 0000 0151                             lcd_putsf("Press \"Select\"");
	__POINTW2FN _0x0,307
	RCALL _lcd_putsf
; 0000 0152                         break;
	RJMP _0x71
; 0000 0153 
; 0000 0154                         case 1:
_0x72:
	RCALL SUBOPT_0x1D
	BRNE _0x73
; 0000 0155                             lcd_putsf("IDs count: ");
	__POINTW2FN _0x0,322
	RCALL _lcd_putsf
; 0000 0156                             FPS_power be ON;
	RCALL SUBOPT_0x4
; 0000 0157                             FPS_open();
; 0000 0158                             lcd_putchar(getEnrolledCount() + '0');
	RCALL _getEnrolledCount
	RCALL SUBOPT_0x21
; 0000 0159                             FPS_power be OFF;
	CBI  0x12,2
; 0000 015A                         break;
	RJMP _0x71
; 0000 015B                         case 2:
_0x73:
	RCALL SUBOPT_0x1E
	BRNE _0x78
; 0000 015C                             lcd_putsf("Voltage: ");
	__POINTW2FN _0x0,334
	RCALL _lcd_putsf
; 0000 015D                             lcd_putchar((mV / 1000) % 10 + '0');
	RCALL SUBOPT_0x19
	RCALL SUBOPT_0x22
	RCALL SUBOPT_0x23
; 0000 015E                             lcd_putchar('.');
	LDI  R26,LOW(46)
	RCALL _lcd_putchar
; 0000 015F                             lcd_putchar((mV / 100) % 10 + '0');
	RCALL SUBOPT_0x19
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	RCALL SUBOPT_0x23
; 0000 0160                             lcd_putchar((mV / 10) % 10 + '0');
	RCALL SUBOPT_0x19
	RCALL SUBOPT_0xE
	RCALL SUBOPT_0x23
; 0000 0161                             lcd_putsf("V");
	__POINTW2FN _0x0,344
	RCALL _lcd_putsf
; 0000 0162 
; 0000 0163                             refreshMenu = 1;
	RCALL SUBOPT_0x16
; 0000 0164                             delay_ms(500);
	RCALL SUBOPT_0x24
; 0000 0165                         break;
	RJMP _0x71
; 0000 0166                         case 3:
_0x78:
	RCALL SUBOPT_0x1F
	BRNE _0x71
; 0000 0167                             lcd_putsf("FPS count:");
	__POINTW2FN _0x0,346
	RCALL SUBOPT_0x0
; 0000 0168                             lcd_gotoxy(0,1);
; 0000 0169                             lcd_putchar((fpsCount / 1000) % 10 + '0');
	RCALL SUBOPT_0x25
	RCALL SUBOPT_0x22
	RCALL SUBOPT_0x26
	RCALL SUBOPT_0x21
; 0000 016A                             lcd_putchar((fpsCount / 100) % 10 + '0');
	RCALL SUBOPT_0x25
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	RCALL SUBOPT_0x26
	RCALL SUBOPT_0x21
; 0000 016B                             lcd_putchar((fpsCount / 10) % 10 + '0');
	RCALL SUBOPT_0x25
	RCALL SUBOPT_0xE
	RCALL SUBOPT_0x26
	RCALL SUBOPT_0x21
; 0000 016C                             lcd_putchar((fpsCount / 1) % 10 + '0');
	RCALL SUBOPT_0x25
	RCALL SUBOPT_0x15
	RCALL SUBOPT_0x21
; 0000 016D 
; 0000 016E                         break;
; 0000 016F                     }
_0x71:
; 0000 0170                 break;
; 0000 0171             }
_0x5E:
; 0000 0172         }
; 0000 0173 
; 0000 0174         if (cancel_PB is pressed && options_PB is pressed)
_0x5B:
	RCALL SUBOPT_0x9
	BRNE _0x7B
	RCALL SUBOPT_0x12
	BREQ _0x7C
_0x7B:
	RJMP _0x7A
_0x7C:
; 0000 0175             controllerReset();
	RCALL _controllerReset
; 0000 0176 
; 0000 0177         if (options_PB is pressed)
_0x7A:
	SBIC 0x10,7
	RJMP _0x7D
; 0000 0178         {
; 0000 0179             soundTick();
	RCALL _soundTick
; 0000 017A             while(options_PB is pressed);
_0x7E:
	SBIS 0x10,7
	RJMP _0x7E
; 0000 017B             if (menuOpt == -1)
	LDI  R30,LOW(255)
	CP   R30,R5
	BRNE _0x81
; 0000 017C             {
; 0000 017D                 if (askAuthentication())
	RCALL _askAuthentication
	CPI  R30,0
	BREQ _0x82
; 0000 017E                 {
; 0000 017F                     soundOK();
	RCALL _soundOK
; 0000 0180                     menuOpt = 0;
	CLR  R5
; 0000 0181                     refreshMenu = 1;
	RJMP _0xB5
; 0000 0182                 }
; 0000 0183                 else
_0x82:
; 0000 0184                 {
; 0000 0185                     soundCancel();
	RCALL _soundCancel
; 0000 0186                     refreshMenu = 1;
_0xB5:
	LDI  R30,LOW(1)
	MOV  R4,R30
; 0000 0187                 }
; 0000 0188             }
; 0000 0189             else
	RJMP _0x84
_0x81:
; 0000 018A             {
; 0000 018B                 refreshMenu = 1;
	RCALL SUBOPT_0x16
; 0000 018C                 menuOpt++;
	INC  R5
; 0000 018D                 i = 0;
	LDI  R17,LOW(0)
; 0000 018E                 if (menuOpt == 5)
	LDI  R30,LOW(5)
	CP   R30,R5
	BRNE _0x85
; 0000 018F                     menuOpt = 0;
	CLR  R5
; 0000 0190             }
_0x85:
_0x84:
; 0000 0191         }
; 0000 0192         else if (select_PB is pressed)
	RJMP _0x86
_0x7D:
	SBIC 0x10,6
	RJMP _0x87
; 0000 0193         {
; 0000 0194             if (menuOpt >= 0)
	LDI  R30,LOW(0)
	CP   R5,R30
	BRGE PC+2
	RJMP _0x88
; 0000 0195             {
; 0000 0196                 refreshMenu = 1;
	RCALL SUBOPT_0x16
; 0000 0197                 if ((i % 4) == 3 && menuOpt == 4)
	RCALL SUBOPT_0x20
	SBIW R30,3
	BRNE _0x8A
	LDI  R30,LOW(4)
	CP   R30,R5
	BREQ _0x8B
_0x8A:
	RJMP _0x89
_0x8B:
; 0000 0198                 {
; 0000 0199                     delay_ms(500);
	RCALL SUBOPT_0x24
; 0000 019A                     if (select_PB is pressed)
	SBIC 0x10,6
	RJMP _0x8C
; 0000 019B                         delay_ms(2000);
	LDI  R26,LOW(2000)
	LDI  R27,HIGH(2000)
	RCALL _delay_ms
; 0000 019C                     if (select_PB is pressed)
_0x8C:
	SBIC 0x10,6
	RJMP _0x8D
; 0000 019D                     {
; 0000 019E                         fpsCount = 0;
	LDI  R26,LOW(_fpsCount)
	LDI  R27,HIGH(_fpsCount)
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RCALL __EEPROMWRW
; 0000 019F                         i--;
	SUBI R17,1
; 0000 01A0                         soundSuccess();
	RCALL _soundSuccess
; 0000 01A1                     }
; 0000 01A2                     else
	RJMP _0x8E
_0x8D:
; 0000 01A3                     {
; 0000 01A4                         soundOK();
	RCALL _soundOK
; 0000 01A5                         while(select_PB is pressed);
_0x8F:
	SBIS 0x10,6
	RJMP _0x8F
; 0000 01A6                     }
_0x8E:
; 0000 01A7                 }
; 0000 01A8                 else
	RJMP _0x92
_0x89:
; 0000 01A9                 {
; 0000 01AA                     soundOK();
	RCALL _soundOK
; 0000 01AB                     while(select_PB is pressed);
_0x93:
	SBIS 0x10,6
	RJMP _0x93
; 0000 01AC                 }
_0x92:
; 0000 01AD 
; 0000 01AE                 switch(menuOpt)
	RCALL SUBOPT_0x17
; 0000 01AF                 {
; 0000 01B0                     case 0: // securityOpt
	SBIW R30,0
	BRNE _0x99
; 0000 01B1                         if (securityMethod == 0 || securityMethod == 1)
	RCALL SUBOPT_0x1C
	CPI  R30,0
	BREQ _0x9B
	CPI  R30,LOW(0x1)
	BRNE _0x9A
_0x9B:
; 0000 01B2                             securityMethod++;
	LDI  R26,LOW(_securityMethod)
	LDI  R27,HIGH(_securityMethod)
	RCALL SUBOPT_0xC
; 0000 01B3                         else
	RJMP _0x9D
_0x9A:
; 0000 01B4                             securityMethod = 0;
	LDI  R26,LOW(_securityMethod)
	LDI  R27,HIGH(_securityMethod)
	LDI  R30,LOW(0)
	RCALL __EEPROMWRB
; 0000 01B5                     break;
_0x9D:
	RJMP _0x98
; 0000 01B6 
; 0000 01B7                     case 1:
_0x99:
	RCALL SUBOPT_0x1D
	BRNE _0x9E
; 0000 01B8                         registerID();
	RCALL _registerID
; 0000 01B9                     break;
	RJMP _0x98
; 0000 01BA                     case 2:
_0x9E:
	RCALL SUBOPT_0x1E
	BRNE _0x9F
; 0000 01BB                         deleteIdByFinger(0);
	LDI  R26,LOW(0)
	RCALL _deleteIdByFinger
; 0000 01BC                     break;
	RJMP _0x98
; 0000 01BD                     case 3:
_0x9F:
	RCALL SUBOPT_0x1F
	BRNE _0xA0
; 0000 01BE                         deleteIdByFinger(1);
	LDI  R26,LOW(1)
	RCALL _deleteIdByFinger
; 0000 01BF                     break;
	RJMP _0x98
; 0000 01C0                     case 4:
_0xA0:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x98
; 0000 01C1                         i ++;
	SUBI R17,-1
; 0000 01C2                         refreshMenu = 1;
	RCALL SUBOPT_0x16
; 0000 01C3                     break;
; 0000 01C4                 }
_0x98:
; 0000 01C5             }
; 0000 01C6         }
_0x88:
; 0000 01C7         else if (cancel_PB is pressed && menuOpt >= 0)
	RJMP _0xA2
_0x87:
	RCALL SUBOPT_0x9
	BRNE _0xA4
	LDI  R30,LOW(0)
	CP   R5,R30
	BRGE _0xA5
_0xA4:
	RJMP _0xA3
_0xA5:
; 0000 01C8         {
; 0000 01C9             soundCancel();
	RCALL _soundCancel
; 0000 01CA             menuOpt = -1;
	LDI  R30,LOW(255)
	MOV  R5,R30
; 0000 01CB             refreshMenu = 1;
	RCALL SUBOPT_0x16
; 0000 01CC         }
; 0000 01CD 
; 0000 01CE         else // open the door
	RJMP _0xA6
_0xA3:
; 0000 01CF         {
; 0000 01D0             if (userHand is present && menuOpt == -1)
	RCALL _getProximity
	CPI  R30,LOW(0x1)
	BRNE _0xA8
	LDI  R30,LOW(255)
	CP   R30,R5
	BREQ _0xA9
_0xA8:
	RJMP _0xA7
_0xA9:
; 0000 01D1             {
; 0000 01D2                 i = 0;
	LDI  R17,LOW(0)
; 0000 01D3                 if (securityMethod == 1) // smart security
	RCALL SUBOPT_0x1C
	CPI  R30,LOW(0x1)
	BRNE _0xAA
; 0000 01D4                 {
; 0000 01D5                     {
; 0000 01D6                         lcd_gotoxy(notSpace, 0);
	RCALL SUBOPT_0x1A
; 0000 01D7                         lcd_putchar(0);
	LDI  R26,LOW(0)
	RCALL _lcd_putchar
; 0000 01D8                     }
; 0000 01D9                     if (getIdFinally(3, 1) < 8)
	LDI  R30,LOW(3)
	ST   -Y,R30
	LDI  R26,LOW(1)
	RCALL _getIdFinally
	CPI  R30,LOW(0x8)
	BRSH _0xAB
; 0000 01DA                     {
; 0000 01DB                         i = 1;
	LDI  R17,LOW(1)
; 0000 01DC                         bip();
	RCALL _bip
; 0000 01DD                     }
; 0000 01DE                     else
	RJMP _0xAC
_0xAB:
; 0000 01DF                     {
; 0000 01E0                         i = 0;
	LDI  R17,LOW(0)
; 0000 01E1                         delay_ms(2000);
	LDI  R26,LOW(2000)
	LDI  R27,HIGH(2000)
	RCALL _delay_ms
; 0000 01E2                     }
_0xAC:
; 0000 01E3                 }
; 0000 01E4                 else if (securityMethod == 2)// open always
	RJMP _0xAD
_0xAA:
	RCALL SUBOPT_0x1C
	CPI  R30,LOW(0x2)
	BRNE _0xAE
; 0000 01E5                     i = 1;
	LDI  R17,LOW(1)
; 0000 01E6                 else
	RJMP _0xAF
_0xAE:
; 0000 01E7                 {
; 0000 01E8                     soundError();
	RCALL _soundError
; 0000 01E9                     i = 0;
	LDI  R17,LOW(0)
; 0000 01EA                 }
_0xAF:
_0xAD:
; 0000 01EB                 if (i == 1)
	CPI  R17,1
	BRNE _0xB0
; 0000 01EC                 {
; 0000 01ED                     lockMotorRoutine();
	RCALL _lockMotorRoutine
; 0000 01EE                     //open door
; 0000 01EF                 }
; 0000 01F0             }
_0xB0:
; 0000 01F1         }
_0xA7:
_0xA6:
_0xA2:
_0x86:
; 0000 01F2         #asm("WDR")
	WDR
; 0000 01F3     }
	RJMP _0x51
; 0000 01F4 }
_0xB1:
	RJMP _0xB1
;#include <mega8.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;#include <stdlib.h>
;#include <delay.h>
;
;unsigned int adc_data;
;#define ADC_VREF_TYPE 0xC0
;
;// ADC interrupt service routine
;interrupt [ADC_INT] void adc_isr(void)
; 0001 000A {

	.CSEG
_adc_isr:
; 0001 000B // Read the AD conversion result
; 0001 000C adc_data=ADCW;
	__INWR 6,7,4
; 0001 000D }
	RETI
;
;// Read the AD conversion result
;// with noise canceling
;unsigned int read_adc_(unsigned char adc_input)
; 0001 0012 {
_read_adc_:
; 0001 0013 #asm("sei");
	ST   -Y,R26
;	adc_input -> Y+0
	sei
; 0001 0014 ADMUX=adc_input | (ADC_VREF_TYPE & 0xff);
	LD   R30,Y
	ORI  R30,LOW(0xC0)
	OUT  0x7,R30
; 0001 0015 // Delay needed for the stabilization of the ADC input voltage
; 0001 0016 delay_us(10);
	__DELAY_USB 27
; 0001 0017 #asm
; 0001 0018     in   r30,mcucr
    in   r30,mcucr
; 0001 0019     cbr  r30,__sm_mask
    cbr  r30,__sm_mask
; 0001 001A     sbr  r30,__se_bit | __sm_adc_noise_red
    sbr  r30,__se_bit | __sm_adc_noise_red
; 0001 001B     out  mcucr,r30
    out  mcucr,r30
; 0001 001C     sleep
    sleep
; 0001 001D     cbr  r30,__se_bit
    cbr  r30,__se_bit
; 0001 001E     out  mcucr,r30
    out  mcucr,r30
; 0001 001F #endasm
; 0001 0020 return adc_data;
	MOVW R30,R6
	RJMP _0x20C0001
; 0001 0021 }
;unsigned int read_adc__(unsigned char adc_input)
; 0001 0023 {
_read_adc__:
; 0001 0024     signed long num = 0;
; 0001 0025     signed int temp = 0;
; 0001 0026     char i = 0, rc = 0;
; 0001 0027     //return read_adc_(adc_input);
; 0001 0028     for (i = 0; i < 10; i++)
	ST   -Y,R26
	RCALL SUBOPT_0x27
	RCALL SUBOPT_0x28
	RCALL __SAVELOCR4
;	adc_input -> Y+8
;	num -> Y+4
;	temp -> R16,R17
;	i -> R19
;	rc -> R18
	__GETWRN 16,17,0
	LDI  R19,0
	LDI  R18,0
	LDI  R19,LOW(0)
_0x20004:
	CPI  R19,10
	BRSH _0x20005
; 0001 0029     {
; 0001 002A         num += read_adc_(adc_input);
	LDD  R26,Y+8
	RCALL _read_adc_
	RCALL SUBOPT_0x29
	CLR  R22
	CLR  R23
	RCALL SUBOPT_0x2A
; 0001 002B     }
	SUBI R19,-1
	RJMP _0x20004
_0x20005:
; 0001 002C     num /= 10;
	RCALL SUBOPT_0x29
	RCALL SUBOPT_0x2B
; 0001 002D     //we have the initial
; 0001 002E     while (rc < 3)
_0x20006:
	CPI  R18,3
	BRSH _0x20008
; 0001 002F     {
; 0001 0030         temp = read_adc_(adc_input);
	LDD  R26,Y+8
	RCALL _read_adc_
	MOVW R16,R30
; 0001 0031         if (temp > num + 5 || temp < num - 5)
	RCALL SUBOPT_0x2C
	__ADDD1N 5
	MOVW R26,R16
	RCALL __CWD2
	RCALL __CPD12
	BRLT _0x2000A
	RCALL SUBOPT_0x2C
	__SUBD1N 5
	MOVW R26,R16
	RCALL __CWD2
	RCALL __CPD21
	BRGE _0x20009
_0x2000A:
; 0001 0032             rc--;
	SUBI R18,1
; 0001 0033         else rc++;
	RJMP _0x2000C
_0x20009:
	SUBI R18,-1
; 0001 0034         if (rc <= 3)
_0x2000C:
	CPI  R18,4
	BRSH _0x2000D
; 0001 0035         {
; 0001 0036             num = ((num * 1) + (temp * 9)) / 10;
	MOVW R30,R16
	LDI  R26,LOW(9)
	LDI  R27,HIGH(9)
	RCALL __MULW12
	RCALL SUBOPT_0x29
	RCALL SUBOPT_0x2D
; 0001 0037             rc = 0;
	LDI  R18,LOW(0)
; 0001 0038         }
; 0001 0039         num = (long)((num * 9) + (long)(temp * 1)) / 10;
_0x2000D:
	RCALL SUBOPT_0x2C
	__GETD2N 0x9
	RCALL __MULD12
	RCALL SUBOPT_0x2E
	MOVW R30,R16
	RCALL SUBOPT_0x2D
; 0001 003A     }
	RJMP _0x20006
_0x20008:
; 0001 003B     return num;
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	RCALL __LOADLOCR4
	ADIW R28,9
	RET
; 0001 003C     //return (read_adc_(adc_input) + read_adc_(adc_input) + read_adc_(adc_input)) / 3;
; 0001 003D }
;#define adcSamples 5
;unsigned int read_adc(unsigned char adc_input)
; 0001 0040 {
_read_adc:
; 0001 0041     signed int samples[adcSamples];
; 0001 0042     signed int avg = 0, ans = 0;
; 0001 0043     signed int minV = 1024, maxV = 0;
; 0001 0044     char i = 0, valCount = 0;
; 0001 0045 
; 0001 0046     for (i = 0; i < adcSamples; i++)
	ST   -Y,R26
	SBIW R28,14
	LDI  R30,LOW(0)
	ST   Y,R30
	RCALL SUBOPT_0x13
	RCALL SUBOPT_0x28
	RCALL SUBOPT_0x2F
;	adc_input -> Y+20
;	samples -> Y+10
;	avg -> R16,R17
;	ans -> R18,R19
;	minV -> R20,R21
;	maxV -> Y+8
;	i -> Y+7
;	valCount -> Y+6
	__GETWRN 20,21,1024
	RCALL SUBOPT_0x30
_0x2000F:
	RCALL SUBOPT_0x31
	BRSH _0x20010
; 0001 0047     {
; 0001 0048         //delay_ms(10);
; 0001 0049         samples[i] = read_adc__(adc_input);
	RCALL SUBOPT_0x32
	ADD  R30,R26
	ADC  R31,R27
	PUSH R31
	PUSH R30
	LDD  R26,Y+20
	RCALL _read_adc__
	POP  R26
	POP  R27
	ST   X+,R30
	ST   X,R31
; 0001 004A     }
	RCALL SUBOPT_0x33
	RJMP _0x2000F
_0x20010:
; 0001 004B 
; 0001 004C     for (i = 0; i < adcSamples; i++)
	RCALL SUBOPT_0x30
_0x20012:
	RCALL SUBOPT_0x31
	BRSH _0x20013
; 0001 004D     {
; 0001 004E         avg += samples[i];
	RCALL SUBOPT_0x32
	RCALL SUBOPT_0x34
	__ADDWRR 16,17,30,31
; 0001 004F     }
	RCALL SUBOPT_0x33
	RJMP _0x20012
_0x20013:
; 0001 0050     avg /= adcSamples;
	MOVW R26,R16
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	RCALL __DIVW21
	MOVW R16,R30
; 0001 0051     for (i = 0; i < adcSamples; i++)
	RCALL SUBOPT_0x30
_0x20015:
	RCALL SUBOPT_0x31
	BRSH _0x20016
; 0001 0052     {
; 0001 0053         if (abs(samples[i] - avg) >= maxV)
	RCALL SUBOPT_0x32
	RCALL SUBOPT_0x34
	RCALL SUBOPT_0x35
	MOVW R26,R30
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	CP   R26,R30
	CPC  R27,R31
	BRLO _0x20017
; 0001 0054             maxV = abs(samples[i] - avg);
	RCALL SUBOPT_0x32
	RCALL SUBOPT_0x34
	RCALL SUBOPT_0x35
	STD  Y+8,R30
	STD  Y+8+1,R31
; 0001 0055         if (abs(samples[i] - avg) <= minV)
_0x20017:
	RCALL SUBOPT_0x32
	RCALL SUBOPT_0x34
	RCALL SUBOPT_0x35
	CP   R20,R30
	CPC  R21,R31
	BRLO _0x20018
; 0001 0056             minV = abs(samples[i] - avg);
	RCALL SUBOPT_0x32
	RCALL SUBOPT_0x34
	RCALL SUBOPT_0x35
	MOVW R20,R30
; 0001 0057     }
_0x20018:
	RCALL SUBOPT_0x33
	RJMP _0x20015
_0x20016:
; 0001 0058     minV = (minV * 8 + maxV * 2) / 10;
	MOVW R30,R20
	RCALL __LSLW3
	MOVW R26,R30
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	RCALL SUBOPT_0xE
	RCALL __DIVW21
	MOVW R20,R30
; 0001 0059     for (i = 0; i < adcSamples; i++)
	RCALL SUBOPT_0x30
_0x2001A:
	RCALL SUBOPT_0x31
	BRSH _0x2001B
; 0001 005A     {
; 0001 005B         if (abs(samples[i] - avg) <= minV)
	RCALL SUBOPT_0x32
	RCALL SUBOPT_0x34
	RCALL SUBOPT_0x35
	CP   R20,R30
	CPC  R21,R31
	BRLO _0x2001C
; 0001 005C         {
; 0001 005D             ans += samples[i];
	RCALL SUBOPT_0x32
	RCALL SUBOPT_0x34
	__ADDWRR 18,19,30,31
; 0001 005E             valCount++;
	LDD  R30,Y+6
	SUBI R30,-LOW(1)
	STD  Y+6,R30
; 0001 005F         }
; 0001 0060     }
_0x2001C:
	RCALL SUBOPT_0x33
	RJMP _0x2001A
_0x2001B:
; 0001 0061     return ans / valCount;
	LDD  R30,Y+6
	RCALL SUBOPT_0x11
	MOVW R26,R18
	RCALL __DIVW21
	RCALL __LOADLOCR6
	ADIW R28,21
	RET
; 0001 0062 }
;
;void adc_init(void)
; 0001 0065 {
_adc_init:
; 0001 0066 
; 0001 0067 // Analog Comparator initialization
; 0001 0068 // Analog Comparator: Off
; 0001 0069 // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0001 006A ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0001 006B SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0001 006C 
; 0001 006D // ADC initialization
; 0001 006E // ADC Clock frequency: 1000.000 kHz
; 0001 006F // ADC Voltage Reference: Int., cap. on AREF
; 0001 0070 ADMUX=ADC_VREF_TYPE & 0xff;
	LDI  R30,LOW(192)
	OUT  0x7,R30
; 0001 0071 ADCSRA=0x8B;
	LDI  R30,LOW(139)
	OUT  0x6,R30
; 0001 0072 }
	RET
;#include <mega8.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;#include "projDefines.h"
;
;#ifndef RXB8
;#define RXB8 1
;#endif
;
;#ifndef TXB8
;#define TXB8 0
;#endif
;
;#ifndef UPE
;#define UPE 2
;#endif
;
;#ifndef DOR
;#define DOR 3
;#endif
;
;#ifndef FE
;#define FE 4
;#endif
;
;#ifndef UDRE
;#define UDRE 5
;#endif
;
;#ifndef RXC
;#define RXC 7
;#endif
;
;#define FRAMING_ERROR (1<<FE)
;#define PARITY_ERROR (1<<UPE)
;#define DATA_OVERRUN (1<<DOR)
;#define DATA_REGISTER_EMPTY (1<<UDRE)
;#define RX_COMPLETE (1<<RXC)
;
;// USART Receiver buffer
;#define RX_BUFFER_SIZE 16
;char rx_buffer[RX_BUFFER_SIZE];
;
;#if RX_BUFFER_SIZE <= 256
;unsigned char rx_wr_index,rx_rd_index,rx_counter;
;#else
;unsigned int rx_wr_index,rx_rd_index,rx_counter;
;#endif
;
;// This flag is set on USART Receiver buffer overflow
;bit rx_buffer_overflow;
;
;// USART Receiver interrupt service routine
;interrupt [USART_RXC] void usart_rx_isr(void)
; 0002 0035 {

	.CSEG
_usart_rx_isr:
	ST   -Y,R26
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0002 0036 char status,data;
; 0002 0037 status=UCSRA;
	RCALL __SAVELOCR2
;	status -> R17
;	data -> R16
	IN   R17,11
; 0002 0038 data=UDR;
	IN   R16,12
; 0002 0039 if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
	MOV  R30,R17
	ANDI R30,LOW(0x1C)
	BRNE _0x40003
; 0002 003A    {
; 0002 003B    rx_buffer[rx_wr_index++]=data;
	MOV  R30,R9
	INC  R9
	RCALL SUBOPT_0x11
	SUBI R30,LOW(-_rx_buffer)
	SBCI R31,HIGH(-_rx_buffer)
	ST   Z,R16
; 0002 003C #if RX_BUFFER_SIZE == 256
; 0002 003D    // special case for receiver buffer size=256
; 0002 003E    if (++rx_counter == 0) rx_buffer_overflow=1;
; 0002 003F #else
; 0002 0040    if (rx_wr_index == RX_BUFFER_SIZE) rx_wr_index=0;
	LDI  R30,LOW(16)
	CP   R30,R9
	BRNE _0x40004
	CLR  R9
; 0002 0041    if (++rx_counter == RX_BUFFER_SIZE)
_0x40004:
	LDS  R26,_rx_counter
	SUBI R26,-LOW(1)
	STS  _rx_counter,R26
	CPI  R26,LOW(0x10)
	BRNE _0x40005
; 0002 0042       {
; 0002 0043       rx_counter=0;
	LDI  R30,LOW(0)
	STS  _rx_counter,R30
; 0002 0044       rx_buffer_overflow=1;
	SET
	BLD  R2,0
; 0002 0045       }
; 0002 0046 #endif
; 0002 0047    }
_0x40005:
; 0002 0048 }
_0x40003:
	RCALL __LOADLOCR2P
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R26,Y+
	RETI
;
;#ifndef _DEBUG_TERMINAL_IO_
;// Get a character from the USART Receiver buffer
;#define _ALTERNATE_GETCHAR_
;#pragma used+
;char getchar(void)
; 0002 004F {
_getchar:
; 0002 0050 char data;
; 0002 0051 dontWDR = 1;
	ST   -Y,R17
;	data -> R17
	LDI  R30,LOW(1)
	STS  _dontWDR,R30
; 0002 0052 while (rx_counter==0);
_0x40006:
	LDS  R30,_rx_counter
	CPI  R30,0
	BREQ _0x40006
; 0002 0053 data=rx_buffer[rx_rd_index++];
	MOV  R30,R8
	INC  R8
	RCALL SUBOPT_0x11
	SUBI R30,LOW(-_rx_buffer)
	SBCI R31,HIGH(-_rx_buffer)
	LD   R17,Z
; 0002 0054 #if RX_BUFFER_SIZE != 256
; 0002 0055 if (rx_rd_index == RX_BUFFER_SIZE) rx_rd_index=0;
	LDI  R30,LOW(16)
	CP   R30,R8
	BRNE _0x40009
	CLR  R8
; 0002 0056 #endif
; 0002 0057 #asm("cli")
_0x40009:
	cli
; 0002 0058 --rx_counter;
	LDS  R30,_rx_counter
	SUBI R30,LOW(1)
	STS  _rx_counter,R30
; 0002 0059 #asm("sei")
	sei
; 0002 005A dontWDR = 0;
	LDI  R30,LOW(0)
	STS  _dontWDR,R30
; 0002 005B return data;
	RJMP _0x20C0009
; 0002 005C }
;#pragma used-
;#endif
;
;// USART Transmitter buffer
;#define TX_BUFFER_SIZE 16
;char tx_buffer[TX_BUFFER_SIZE];
;
;#if TX_BUFFER_SIZE <= 256
;unsigned char tx_wr_index,tx_rd_index,tx_counter;
;#else
;unsigned int tx_wr_index,tx_rd_index,tx_counter;
;#endif
;
;// USART Transmitter interrupt service routine
;interrupt [USART_TXC] void usart_tx_isr(void)
; 0002 006C {
_usart_tx_isr:
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0002 006D if (tx_counter)
	TST  R13
	BREQ _0x4000A
; 0002 006E    {
; 0002 006F    --tx_counter;
	DEC  R13
; 0002 0070    UDR=tx_buffer[tx_rd_index++];
	MOV  R30,R10
	INC  R10
	RCALL SUBOPT_0x11
	SUBI R30,LOW(-_tx_buffer)
	SBCI R31,HIGH(-_tx_buffer)
	LD   R30,Z
	OUT  0xC,R30
; 0002 0071 #if TX_BUFFER_SIZE != 256
; 0002 0072    if (tx_rd_index == TX_BUFFER_SIZE) tx_rd_index=0;
	LDI  R30,LOW(16)
	CP   R30,R10
	BRNE _0x4000B
	CLR  R10
; 0002 0073 #endif
; 0002 0074    }
_0x4000B:
; 0002 0075 }
_0x4000A:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	RETI
;
;#ifndef _DEBUG_TERMINAL_IO_
;// Write a character to the USART Transmitter buffer
;#define _ALTERNATE_PUTCHAR_
;#pragma used+
;void putchar(char c)
; 0002 007C {
_putchar:
; 0002 007D while (tx_counter == TX_BUFFER_SIZE);
	ST   -Y,R26
;	c -> Y+0
_0x4000C:
	LDI  R30,LOW(16)
	CP   R30,R13
	BREQ _0x4000C
; 0002 007E #asm("cli")
	cli
; 0002 007F if (tx_counter || ((UCSRA & DATA_REGISTER_EMPTY)==0))
	TST  R13
	BRNE _0x40010
	SBIC 0xB,5
	RJMP _0x4000F
_0x40010:
; 0002 0080    {
; 0002 0081    tx_buffer[tx_wr_index++]=c;
	MOV  R30,R11
	INC  R11
	RCALL SUBOPT_0x11
	SUBI R30,LOW(-_tx_buffer)
	SBCI R31,HIGH(-_tx_buffer)
	LD   R26,Y
	STD  Z+0,R26
; 0002 0082 #if TX_BUFFER_SIZE != 256
; 0002 0083    if (tx_wr_index == TX_BUFFER_SIZE) tx_wr_index=0;
	LDI  R30,LOW(16)
	CP   R30,R11
	BRNE _0x40012
	CLR  R11
; 0002 0084 #endif
; 0002 0085    ++tx_counter;
_0x40012:
	INC  R13
; 0002 0086    }
; 0002 0087 else
	RJMP _0x40013
_0x4000F:
; 0002 0088    UDR=c;
	LD   R30,Y
	OUT  0xC,R30
; 0002 0089 #asm("sei")
_0x40013:
	sei
; 0002 008A }
	RJMP _0x20C0001
;#pragma used-
;#endif
;
;void uart_init(void)
; 0002 008F {
_uart_init:
; 0002 0090     // USART initialization
; 0002 0091     // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0002 0092     // USART Receiver: On
; 0002 0093     // USART Transmitter: On
; 0002 0094     // USART Mode: Asynchronous
; 0002 0095     // USART Baud Rate: 9600
; 0002 0096     UCSRA=0x00;
	LDI  R30,LOW(0)
	OUT  0xB,R30
; 0002 0097     UCSRB=0xD8;
	LDI  R30,LOW(216)
	OUT  0xA,R30
; 0002 0098     UCSRC=0x86;
	LDI  R30,LOW(134)
	OUT  0x20,R30
; 0002 0099     UBRRH=0x00;
	LDI  R30,LOW(0)
	OUT  0x20,R30
; 0002 009A     UBRRL=0x33;
	LDI  R30,LOW(51)
	OUT  0x9,R30
; 0002 009B }
	RET
;#include <mega8.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;#include "projHeaders.h"
;#include "projDefines.h"
;#include <alcd.h>
;#include <delay.h>
;#include "customCharsCG.h"
;
;char cpuHaltAllowed;
;// Timer 0 overflow interrupt service routine
;//used for charge and LCD contrast controller
;int mV;
;char powerMode;
;unsigned char dontWDR;
;eeprom unsigned int fpsCount;
;
;void normalizeContrast(void)
; 0003 0011 {

	.CSEG
_normalizeContrast:
; 0003 0012     if (mV > 4800)
	RCALL SUBOPT_0x36
	BRLT _0x60003
; 0003 0013         OCR2 = 0;
	LDI  R30,LOW(0)
	RJMP _0x60064
; 0003 0014     else if (mV > 4600)
_0x60003:
	RCALL SUBOPT_0x19
	CPI  R26,LOW(0x11F9)
	LDI  R30,HIGH(0x11F9)
	CPC  R27,R30
	BRLT _0x60005
; 0003 0015         OCR2 = 50;
	LDI  R30,LOW(50)
	RJMP _0x60064
; 0003 0016     else if (mV > 4300)
_0x60005:
	RCALL SUBOPT_0x1B
	BRLT _0x60007
; 0003 0017         OCR2 = 100;
	LDI  R30,LOW(100)
	RJMP _0x60064
; 0003 0018     else if (mV > 4100)
_0x60007:
	RCALL SUBOPT_0x37
	BRLT _0x60009
; 0003 0019         OCR2 = 200;
	LDI  R30,LOW(200)
	RJMP _0x60064
; 0003 001A     else
_0x60009:
; 0003 001B         OCR2 = 249;
	LDI  R30,LOW(249)
_0x60064:
	OUT  0x23,R30
; 0003 001C }
	RET
;unsigned int elapsed_us;
;unsigned int elapsed_ms;
;unsigned int elapsed_sec;
;unsigned char junkFreeTimer;
;unsigned char autoSleepTimer;
;
;
;void incTime (void)
; 0003 0025 {
_incTime:
; 0003 0026     elapsed_us += 800;// precisely 192
	LDS  R30,_elapsed_us
	LDS  R31,_elapsed_us+1
	SUBI R30,LOW(-800)
	SBCI R31,HIGH(-800)
	RCALL SUBOPT_0x38
; 0003 0027     elapsed_ms += 8;
	LDS  R30,_elapsed_ms
	LDS  R31,_elapsed_ms+1
	ADIW R30,8
	RCALL SUBOPT_0x39
; 0003 0028     if (elapsed_us >= 1000) { elapsed_ms ++;    elapsed_us %= 1000; }
	RCALL SUBOPT_0x3A
	RCALL SUBOPT_0x3B
	BRLO _0x6000B
	LDI  R26,LOW(_elapsed_ms)
	LDI  R27,HIGH(_elapsed_ms)
	RCALL SUBOPT_0x3C
	RCALL SUBOPT_0x3A
	RCALL SUBOPT_0x22
	RCALL __MODW21U
	RCALL SUBOPT_0x38
; 0003 0029     if (elapsed_ms >= 1000)
_0x6000B:
	RCALL SUBOPT_0x3D
	RCALL SUBOPT_0x3B
	BRLO _0x6000C
; 0003 002A     {
; 0003 002B         elapsed_sec ++;
	LDI  R26,LOW(_elapsed_sec)
	LDI  R27,HIGH(_elapsed_sec)
	RCALL SUBOPT_0x3C
; 0003 002C         elapsed_ms %= 1000;
	RCALL SUBOPT_0x3D
	RCALL SUBOPT_0x22
	RCALL __MODW21U
	RCALL SUBOPT_0x39
; 0003 002D 
; 0003 002E         if (junkFreeTimer < 60)
	LDS  R26,_junkFreeTimer
	CPI  R26,LOW(0x3C)
	BRSH _0x6000D
; 0003 002F             junkFreeTimer++;
	LDS  R30,_junkFreeTimer
	SUBI R30,-LOW(1)
	STS  _junkFreeTimer,R30
; 0003 0030         if (autoSleepTimer < 255)
_0x6000D:
	LDS  R26,_autoSleepTimer
	CPI  R26,LOW(0xFF)
	BRSH _0x6000E
; 0003 0031             autoSleepTimer++;
	LDS  R30,_autoSleepTimer
	SUBI R30,-LOW(1)
	STS  _autoSleepTimer,R30
; 0003 0032     }
_0x6000E:
; 0003 0033     if (elapsed_sec >= 1000)  { elapsed_sec = 0;    }
_0x6000C:
	RCALL SUBOPT_0x14
	RCALL SUBOPT_0x3B
	BRLO _0x6000F
	LDI  R30,LOW(0)
	STS  _elapsed_sec,R30
	STS  _elapsed_sec+1,R30
; 0003 0034 
; 0003 0035 }
_0x6000F:
	RET
;bit inPowerLoop = 0;
;interrupt [TIM0_OVF] void timer0_ovf_isr(void)
; 0003 0038 {
_timer0_ovf_isr:
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R15
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0003 0039     incTime();
	RCALL _incTime
; 0003 003A     if(inPowerLoop) return;
	SBRC R2,1
	RJMP _0x60069
; 0003 003B     inPowerLoop = 1;
	SET
	BLD  R2,1
; 0003 003C 
; 0003 003D     notLED = !((elapsed_sec % 3 == 0) && (elapsed_ms < 50));
	RCALL SUBOPT_0x14
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	RCALL __MODW21U
	SBIW R30,0
	BRNE _0x60011
	RCALL SUBOPT_0x3D
	SBIW R26,50
	BRSH _0x60011
	LDI  R30,1
	RJMP _0x60012
_0x60011:
	LDI  R30,0
_0x60012:
	CPI  R30,0
	BREQ _0x60013
	CBI  0x18,2
	RJMP _0x60014
_0x60013:
	SBI  0x18,2
_0x60014:
; 0003 003E     if (cpuHaltAllowed)
	LDS  R30,_cpuHaltAllowed
	CPI  R30,0
	BREQ _0x60015
; 0003 003F     {
; 0003 0040         mV = a2v(read_adc(0)) * 1000;
	LDI  R26,LOW(0)
	RCALL _read_adc
	CLR  R22
	CLR  R23
	RCALL __CDF1
	__GETD2N 0x3BF82B5E
	RCALL __MULF12
	RCALL SUBOPT_0x2E
	__GETD1N 0x3FAFBC86
	RCALL __SWAPD12
	RCALL __SUBF12
	__GETD2N 0x447A0000
	RCALL __MULF12
	LDI  R26,LOW(_mV)
	LDI  R27,HIGH(_mV)
	RCALL __CFD1
	ST   X+,R30
	ST   X,R31
; 0003 0041     }
; 0003 0042 
; 0003 0043 
; 0003 0044     if (powerMode is FORCE_CHARGE)
_0x60015:
	LDS  R26,_powerMode
	CPI  R26,LOW(0x7)
	BRNE _0x60016
; 0003 0045     {
; 0003 0046         charging be ON;
	SBI  0x18,0
; 0003 0047         normalizeContrast();
	RCALL _normalizeContrast
; 0003 0048     }
; 0003 0049     else if (mV > maxRated)
	RJMP _0x60019
_0x60016:
	RCALL SUBOPT_0x19
	CPI  R26,LOW(0x157D)
	LDI  R30,HIGH(0x157D)
	CPC  R27,R30
	BRLT _0x6001A
; 0003 004A     {
; 0003 004B         powerMode = POWER_OVERFLOW;
	LDI  R30,LOW(5)
	RCALL SUBOPT_0x3E
; 0003 004C         // just try to reduce the power by overloading
; 0003 004D         charging be ON;
	SBI  0x18,0
; 0003 004E         OCR2 = 0;
	LDI  R30,LOW(0)
	RJMP _0x60065
; 0003 004F     }
; 0003 0050     else if (mV > batteryFull)
_0x6001A:
	RCALL SUBOPT_0x36
	BRLT _0x6001E
; 0003 0051     {
; 0003 0052         if (powerMode == 0) // system start
	LDS  R30,_powerMode
	CPI  R30,0
	BRNE _0x6001F
; 0003 0053         {
; 0003 0054             charging be ON;
	SBI  0x18,0
; 0003 0055             OCR2 = 160;
	LDI  R30,LOW(160)
	OUT  0x23,R30
; 0003 0056             powerMode be ON_CHARGING;
	LDI  R30,LOW(2)
	RJMP _0x60066
; 0003 0057         }
; 0003 0058         else
_0x6001F:
; 0003 0059         {
; 0003 005A             if (charging is ON)
	SBIS 0x18,0
	RJMP _0x60023
; 0003 005B             {
; 0003 005C                 //Battery full, disconnect
; 0003 005D                 charging be OFF;
	CBI  0x18,0
; 0003 005E                 powerMode = ON_EXTERNAL;
	LDI  R30,LOW(1)
	RCALL SUBOPT_0x3E
; 0003 005F                 OCR2 = 0;
	LDI  R30,LOW(0)
	OUT  0x23,R30
; 0003 0060             }
; 0003 0061             else    // over charged Battery, can't do anything
	RJMP _0x60026
_0x60023:
; 0003 0062                 powerMode = ON_EXTERNAL;
	LDI  R30,LOW(1)
_0x60066:
	STS  _powerMode,R30
; 0003 0063         }
_0x60026:
; 0003 0064     }
; 0003 0065     else if (mV > onBattery)
	RJMP _0x60027
_0x6001E:
	RCALL SUBOPT_0x37
	BRLT _0x60028
; 0003 0066     {
; 0003 0067         charging be ON;
	SBI  0x18,0
; 0003 0068         //either discharging in high state or charging normally, lets c
; 0003 0069         if (mV > noExternal) //was not discharging
	RCALL SUBOPT_0x19
	CPI  R26,LOW(0x1195)
	LDI  R30,HIGH(0x1195)
	CPC  R27,R30
	BRLT _0x6002B
; 0003 006A             powerMode = ON_CHARGING;
	LDI  R30,LOW(2)
	RJMP _0x60067
; 0003 006B         else
_0x6002B:
; 0003 006C             powerMode = ON_BATTERY;
	LDI  R30,LOW(3)
_0x60067:
	STS  _powerMode,R30
; 0003 006D         //let the contrast adjust on next cycle
; 0003 006E 
; 0003 006F         //only if returns in same branch
; 0003 0070         normalizeContrast();
	RCALL _normalizeContrast
; 0003 0071     }
; 0003 0072     else if (mV > batteryLow)
	RJMP _0x6002D
_0x60028:
	RCALL SUBOPT_0x19
	CPI  R26,LOW(0xED9)
	LDI  R30,HIGH(0xED9)
	CPC  R27,R30
	BRLT _0x6002E
; 0003 0073     {
; 0003 0074         if (charging is ON)
	SBIC 0x18,0
; 0003 0075         {
; 0003 0076             //either too low battery or discharging already
; 0003 0077             powerMode = ON_BATTERY;
	RJMP _0x60068
; 0003 0078         }
; 0003 0079         else
; 0003 007A         {
; 0003 007B             //power falure
; 0003 007C             charging be ON;
	SBI  0x18,0
; 0003 007D 
; 0003 007E             if (powerMode != ON_BATTERY) //first time in branch
	LDS  R26,_powerMode
	CPI  R26,LOW(0x3)
	BREQ _0x60033
; 0003 007F             {
; 0003 0080                 OCR2 = 200;
	LDI  R30,LOW(200)
	OUT  0x23,R30
; 0003 0081                 //soundPowerFailure();
; 0003 0082             }
; 0003 0083             powerMode = ON_BATTERY;
_0x60033:
_0x60068:
	LDI  R30,LOW(3)
	RCALL SUBOPT_0x3E
; 0003 0084         }
; 0003 0085         normalizeContrast();
	RCALL _normalizeContrast
; 0003 0086     }
; 0003 0087     else // battery too low.
	RJMP _0x60034
_0x6002E:
; 0003 0088     {
; 0003 0089         if (powerMode is ON_BATTERY)
	LDS  R26,_powerMode
	CPI  R26,LOW(0x3)
	BRNE _0x60035
; 0003 008A         {
; 0003 008B             charging be ON;
	SBI  0x18,0
; 0003 008C             powerMode = BATTERY_LOW;
	LDI  R30,LOW(4)
	RCALL SUBOPT_0x3E
; 0003 008D             //soundBatteryLow();
; 0003 008E         }
; 0003 008F         else
	RJMP _0x60038
_0x60035:
; 0003 0090         //power failed
; 0003 0091         {
; 0003 0092             charging be ON;
	SBI  0x18,0
; 0003 0093             powerMode = ON_BATTERY;
	LDI  R30,LOW(3)
	RCALL SUBOPT_0x3E
; 0003 0094             OCR2 = 210;
	LDI  R30,LOW(210)
_0x60065:
	OUT  0x23,R30
; 0003 0095             //soundPowerFailure();
; 0003 0096         }
_0x60038:
; 0003 0097     }
_0x60034:
_0x6002D:
_0x60027:
_0x60019:
; 0003 0098     if (!dontWDR)
	LDS  R30,_dontWDR
	CPI  R30,0
	BRNE _0x6003B
; 0003 0099         #asm("WDR")
	WDR
; 0003 009A     inPowerLoop = 0;
_0x6003B:
	CLT
	BLD  R2,1
; 0003 009B }
_0x60069:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R15,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
;
;
;void controller_init(void)
; 0003 009F {
_controller_init:
; 0003 00A0     delay_ms(100);
	RCALL SUBOPT_0x3F
; 0003 00A1     //OSCCAL = 0xFF; // double the internal oscillator speed
; 0003 00A2     cpuHaltAllowed = 0;
	LDI  R30,LOW(0)
	RCALL SUBOPT_0x40
; 0003 00A3     adc_init();
	RCALL _adc_init
; 0003 00A4     lcd_init(16);
	LDI  R26,LOW(16)
	RCALL _lcd_init
; 0003 00A5     uart_init();
	RCALL _uart_init
; 0003 00A6 
; 0003 00A7     init_fingerPrint_char();
	RCALL _init_fingerPrint_char
; 0003 00A8     init_battery_char();
	RCALL _init_battery_char
; 0003 00A9     init_switch_char();
	RCALL _init_switch_char
; 0003 00AA     init_locked_char();
	RCALL _init_locked_char
; 0003 00AB     init_unlocked_char();
	RCALL _init_unlocked_char
; 0003 00AC     init_smilie_char();
	RCALL _init_smilie_char
; 0003 00AD     dontWDR = 0;
	LDI  R30,LOW(0)
	STS  _dontWDR,R30
; 0003 00AE 
; 0003 00AF     DDRB.0 = 1;     //battery charge
	SBI  0x17,0
; 0003 00B0     PORTB.0 = 0;    //battery charge
	CBI  0x18,0
; 0003 00B1 
; 0003 00B2     DDRB.1 = 1; //buzzer
	SBI  0x17,1
; 0003 00B3     PORTB.1 = 0;
	CBI  0x18,1
; 0003 00B4 
; 0003 00B5     DDRB.2 = 1;     //not LED
	SBI  0x17,2
; 0003 00B6     DDRB.2 = 1;     //not LED
	SBI  0x17,2
; 0003 00B7 
; 0003 00B8     DDRB.3 = 1;     //chargepump
	SBI  0x17,3
; 0003 00B9 
; 0003 00BA     DDRB.7 = 1;     //motor
	SBI  0x17,7
; 0003 00BB     PORTB.7 = 0;
	CBI  0x18,7
; 0003 00BC 
; 0003 00BD 
; 0003 00BE     DDRC.0 = 0;     //VCC/Vref
	CBI  0x14,0
; 0003 00BF     PORTC.0 = 0;
	CBI  0x15,0
; 0003 00C0 
; 0003 00C1     DDRD &= ~0xE0; // buttons
	IN   R30,0x11
	ANDI R30,LOW(0x1F)
	OUT  0x11,R30
; 0003 00C2     PORTD |= 0xE0; // buttons
	IN   R30,0x12
	ORI  R30,LOW(0xE0)
	OUT  0x12,R30
; 0003 00C3 
; 0003 00C4     DDRD.0 = 0; //uart
	CBI  0x11,0
; 0003 00C5     DDRD.1 = 1;
	SBI  0x11,1
; 0003 00C6     PORTD.0 = 0;
	CBI  0x12,0
; 0003 00C7     PORTD.1 = 1;
	SBI  0x12,1
; 0003 00C8 
; 0003 00C9     DDRD.2 = 1;  //FPS power
	SBI  0x11,2
; 0003 00CA     PORTD.2 = 0; //FPS power
	CBI  0x12,2
; 0003 00CB 
; 0003 00CC     DDRD.3 = 0;  //IRD
	CBI  0x11,3
; 0003 00CD     PORTD.3 = 0;
	CBI  0x12,3
; 0003 00CE 
; 0003 00CF     //LCD contrast
; 0003 00D0 
; 0003 00D1     // Timer/Counter 2 initialization
; 0003 00D2     // Clock source: System Clock
; 0003 00D3     // Clock value: 1000.000 kHz
; 0003 00D4     // Mode: Fast PWM top=0xFF
; 0003 00D5     // OC2 output: Inverted PWM
; 0003 00D6     ASSR=0x00;
	LDI  R30,LOW(0)
	OUT  0x22,R30
; 0003 00D7     TCCR2=0x7B;
	LDI  R30,LOW(123)
	OUT  0x25,R30
; 0003 00D8     TCNT2=0x00;
	LDI  R30,LOW(0)
	OUT  0x24,R30
; 0003 00D9     OCR2=0x7F;
	LDI  R30,LOW(127)
	OUT  0x23,R30
; 0003 00DA 
; 0003 00DB     // Timer/Counter 0 initialization
; 0003 00DC     // Clock source: System Clock
; 0003 00DD     // Clock value: 31.250 kHz
; 0003 00DE     TCCR0=0x04;
	LDI  R30,LOW(4)
	OUT  0x33,R30
; 0003 00DF     TCNT0=0x00;
	LDI  R30,LOW(0)
	OUT  0x32,R30
; 0003 00E0     TIMSK |= 0x01;
	IN   R30,0x39
	ORI  R30,1
	OUT  0x39,R30
; 0003 00E1 
; 0003 00E2     lcd_clear();
	RCALL _lcd_clear
; 0003 00E3     cpuHaltAllowed = 1;
	LDI  R30,LOW(1)
	RCALL SUBOPT_0x40
; 0003 00E4     notLED be iOFF;
	SBI  0x18,2
; 0003 00E5     powerMode = FORCE_CHARGE;
	LDI  R30,LOW(7)
	RCALL SUBOPT_0x3E
; 0003 00E6 
; 0003 00E7     // Watchdog Timer initialization
; 0003 00E8     // Watchdog Timer Prescaler: OSC/512k
; 0003 00E9     #pragma optsize-
; 0003 00EA     WDTCR=0x1F;
	LDI  R30,LOW(31)
	OUT  0x21,R30
; 0003 00EB     WDTCR=0x0F;
	LDI  R30,LOW(15)
	OUT  0x21,R30
; 0003 00EC     #ifdef _OPTIMIZE_SIZE_
; 0003 00ED     #pragma optsize+
; 0003 00EE     #endif
; 0003 00EF 
; 0003 00F0 
; 0003 00F1     #asm("sei");
	sei
; 0003 00F2 
; 0003 00F3     lcd_putsf("techCREATIONS");
	__POINTW2FN _0x60000,0
	RCALL _lcd_putsf
; 0003 00F4     delay_ms(500);
	RCALL SUBOPT_0x24
; 0003 00F5     failedCount = 0;
	RCALL SUBOPT_0x6
; 0003 00F6     powerMode = ON_CHARGING;
	LDI  R30,LOW(2)
	RCALL SUBOPT_0x3E
; 0003 00F7     lcd_clear();
	RCALL _lcd_clear
; 0003 00F8     delay_ms(10);
	LDI  R26,LOW(10)
	RCALL SUBOPT_0x41
	RJMP _0x20C0008
; 0003 00F9 }
;#include "GPS_GT511x_comDefs.h"
;#include "projDefines.h"
;#include "projHeaders.h"
;#include <mega8.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;#include <delay.h>
;#include <stdint.h>
;#include <stdbool.h>
;#include <stdio.h>
;#include <string.h>
;#include <alcd.h>
;
;#define lowByte(u16) (u16 % 256)
;#define highByte(u16) ((u16 >> 8) % 256)
;#define UseLCDDebug 0
;
;uint8_t txPacket []= 	{0x55, 0xAA, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x0, 0x00, 0x0, 0x00};

	.DSEG
;uint8_t rxPacket [12];
;
;#define rxData (x_)  rxPacket[4 + x_]
;void getCommand(uint16_t com, uint32_t data)
; 0004 0015 {

	.CSEG
_getCommand:
; 0004 0016 	uint16_t chkSum_ = 0, rd_data = 0, i;
; 0004 0017     cpuHaltAllowed = 0;
	RCALL __PUTPARD2
	RCALL SUBOPT_0x2F
;	com -> Y+10
;	data -> Y+6
;	chkSum_ -> R16,R17
;	rd_data -> R18,R19
;	i -> R20,R21
	LDI  R30,LOW(0)
	RCALL SUBOPT_0x40
; 0004 0018 #if UseLCDDebug
; 0004 0019 	lcd_clear();
; 0004 001A     lcd_putsf("Sent\n");
; 0004 001B #endif
; 0004 001C 	for (i = 0; i < 4; i++)
	RCALL SUBOPT_0x42
_0x80005:
	__CPWRN 20,21,4
	BRSH _0x80006
; 0004 001D 	{
; 0004 001E 		txPacket[4 + i] = data % 256; data /= 256;
	MOVW R30,R20
	__ADDW1MN _txPacket,4
	MOVW R26,R30
	LDD  R30,Y+6
	ST   X,R30
	__GETD2S 6
	__GETD1N 0x100
	RCALL __DIVD21U
	__PUTD1S 6
; 0004 001F 	}
	RCALL SUBOPT_0x43
	RJMP _0x80005
_0x80006:
; 0004 0020 	txPacket[8] = com % 256; com /= 256;
	LDD  R30,Y+10
	__PUTB1MN _txPacket,8
	LDD  R30,Y+11
	ANDI R31,HIGH(0x0)
	STD  Y+10,R30
	STD  Y+10+1,R31
; 0004 0021 	txPacket[9] = com % 256;
	LDD  R30,Y+10
	__PUTB1MN _txPacket,9
; 0004 0022 
; 0004 0023 	for(i = 0; i < 10; i++)
	RCALL SUBOPT_0x42
_0x80008:
	__CPWRN 20,21,10
	BRSH _0x80009
; 0004 0024 		chkSum_ += txPacket[i];
	RCALL SUBOPT_0x44
	LD   R30,X
	RCALL SUBOPT_0x11
	__ADDWRR 16,17,30,31
	RCALL SUBOPT_0x43
	RJMP _0x80008
_0x80009:
; 0004 0025 txPacket[10] = chkSum_ % 256; chkSum_ /= 256;
	MOV  R30,R16
	__PUTB1MN _txPacket,10
	MOV  R16,R17
	CLR  R17
; 0004 0026 	txPacket[11] = chkSum_ ;
	__PUTBMRN _txPacket,11,16
; 0004 0027 
; 0004 0028 	for(i = 0; i < 12; i++)
	RCALL SUBOPT_0x42
_0x8000B:
	__CPWRN 20,21,12
	BRSH _0x8000C
; 0004 0029 	{
; 0004 002A 		putchar(txPacket[i]);
	RCALL SUBOPT_0x44
	LD   R26,X
	RCALL _putchar
; 0004 002B 	}
	RCALL SUBOPT_0x43
	RJMP _0x8000B
_0x8000C:
; 0004 002C #if UseLCDDebug
; 0004 002D 	lcd_clear();
; 0004 002E 	lcd_putsf("Got Back.");
; 0004 002F #endif
; 0004 0030 	for (i = 0; i < 12; i++)
	RCALL SUBOPT_0x42
_0x8000E:
	__CPWRN 20,21,12
	BRSH _0x8000F
; 0004 0031 	{
; 0004 0032 		//while(rx_counter == 0);
; 0004 0033 		rd_data = getchar();
	RCALL _getchar
	MOV  R18,R30
	CLR  R19
; 0004 0034 
; 0004 0035 		rxPacket[i] = rd_data;
	MOVW R30,R20
	SUBI R30,LOW(-_rxPacket)
	SBCI R31,HIGH(-_rxPacket)
	ST   Z,R18
; 0004 0036 	}
	RCALL SUBOPT_0x43
	RJMP _0x8000E
_0x8000F:
; 0004 0037     cpuHaltAllowed = 1;
	LDI  R30,LOW(1)
	RCALL SUBOPT_0x40
; 0004 0038 }
	RCALL __LOADLOCR6
	RJMP _0x20C000C
;
;uint8_t setCmosLED(uint8_t state_)
; 0004 003B {
_setCmosLED:
; 0004 003C 	getCommand(CmosLed, state_);
	ST   -Y,R26
;	state_ -> Y+0
	LDI  R30,LOW(18)
	LDI  R31,HIGH(18)
	RCALL SUBOPT_0x45
	RCALL SUBOPT_0x46
; 0004 003D 	return rxPacket[10] == 0x30; // ACK
	RCALL SUBOPT_0x47
	RJMP _0x20C0001
; 0004 003E }
;
;uint8_t FPS_open(void)
; 0004 0041 {
_FPS_open:
; 0004 0042     delay_ms(100);
	RCALL SUBOPT_0x3F
; 0004 0043 	getCommand(FPSOpen, 0);
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RJMP _0x20C000D
; 0004 0044 	return rxPacket[10] == 0x30; // ACK
; 0004 0045 }
;uint8_t FPS_close(void)
; 0004 0047 {
_FPS_close:
; 0004 0048 	getCommand(FPSClose, 0);
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
_0x20C000D:
	ST   -Y,R31
	ST   -Y,R30
	RCALL SUBOPT_0x48
; 0004 0049 	return rxPacket[10] == 0x30; // ACK
	RCALL SUBOPT_0x47
	RET
; 0004 004A }
;void FPS_reset(void)
; 0004 004C {
_FPS_reset:
; 0004 004D 	FPS_open();
	RCALL _FPS_open
; 0004 004E     delay_ms(1000);
	RCALL SUBOPT_0xB
; 0004 004F 	FPS_close();
	RCALL _FPS_close
; 0004 0050 }
	RET
;uint32_t FPS_getInt(uint32_t com)
; 0004 0052 {
_FPS_getInt:
; 0004 0053 	uint32_t ans = 0, i = 0;
; 0004 0054 	getCommand(com, 0);
	RCALL __PUTPARD2
	SBIW R28,8
	LDI  R30,LOW(0)
	ST   Y,R30
	RCALL SUBOPT_0x13
	RCALL SUBOPT_0x28
	LDI  R30,LOW(0)
	STD  Y+4,R30
	STD  Y+5,R30
	STD  Y+6,R30
	RCALL SUBOPT_0x30
;	com -> Y+8
;	ans -> Y+4
;	i -> Y+0
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	RCALL SUBOPT_0x49
; 0004 0055 	for (i = 0; i < 4; i++)
	LDI  R30,LOW(0)
	RCALL __CLRD1S0
_0x80011:
	RCALL __GETD2S0
	__CPD2N 0x4
	BRSH _0x80012
; 0004 0056 	{
; 0004 0057 		ans += rxPacket[4 + i] << (8 * i);
	LD   R30,Y
	LDD  R31,Y+1
	__ADDW1MN _rxPacket,4
	LD   R26,Z
	RCALL SUBOPT_0x41
	LD   R30,Y
	LSL  R30
	LSL  R30
	LSL  R30
	RCALL __CWD2
	RCALL __LSLD12
	RCALL SUBOPT_0x29
	RCALL SUBOPT_0x2A
; 0004 0058 	}
	RCALL SUBOPT_0x4A
	__SUBD1N -1
	RCALL SUBOPT_0x4B
	RJMP _0x80011
_0x80012:
; 0004 0059 	return ans;
	RCALL SUBOPT_0x2C
_0x20C000C:
	ADIW R28,12
	RET
; 0004 005A }
;uint8_t fingerPressed(void)
; 0004 005C {
_fingerPressed:
; 0004 005D 	getCommand(IsPressFinger, 0);
	LDI  R30,LOW(38)
	LDI  R31,HIGH(38)
	RCALL SUBOPT_0x49
; 0004 005E 	return rxPacket[4] ? 0: 1;
	RCALL SUBOPT_0x4C
	BREQ _0x80013
	LDI  R30,LOW(0)
	RJMP _0x80014
_0x80013:
	LDI  R30,LOW(1)
_0x80014:
	RET
; 0004 005F }
;uint32_t getEnrolledCount(void)
; 0004 0061 {
_getEnrolledCount:
; 0004 0062 	return FPS_getInt(GetEnrollCount);
	__GETD2N 0x20
	RCALL _FPS_getInt
	RET
; 0004 0063 }
;uint8_t isEnrolled(uint8_t id)
; 0004 0065 {
_isEnrolled:
; 0004 0066 #if UseLCDDebug
; 0004 0067 	lcd_clear();
; 0004 0068 	lcd_putsf("CheckEnrolled");
; 0004 0069 #endif
; 0004 006A 	getCommand(CheckEnrolled, id);
	ST   -Y,R26
;	id -> Y+0
	LDI  R30,LOW(33)
	LDI  R31,HIGH(33)
	RCALL SUBOPT_0x45
	RCALL SUBOPT_0x46
; 0004 006B 	return rxPacket[4] ? 0: 1;
	RCALL SUBOPT_0x4C
	BREQ _0x80016
	LDI  R30,LOW(0)
	RJMP _0x80017
_0x80016:
	LDI  R30,LOW(1)
_0x80017:
	RJMP _0x20C0001
; 0004 006C }
;uint8_t deleteID(uint8_t id)
; 0004 006E {
_deleteID:
; 0004 006F #if UseLCDDebug
; 0004 0070 	lcd_clear();
; 0004 0071 	lcd_putsf("delete ID");
; 0004 0072 #endif
; 0004 0073 	getCommand(DeleteID, id);
	ST   -Y,R26
;	id -> Y+0
	LDI  R30,LOW(64)
	LDI  R31,HIGH(64)
	RCALL SUBOPT_0x45
	RCALL SUBOPT_0x46
; 0004 0074 	return rxPacket[4] ? 0: 1;
	RCALL SUBOPT_0x4C
	BREQ _0x80019
	LDI  R30,LOW(0)
	RJMP _0x8001A
_0x80019:
	LDI  R30,LOW(1)
_0x8001A:
	RJMP _0x20C0001
; 0004 0075 }
;uint8_t getFingerId(void)
; 0004 0077 {
_getFingerId:
; 0004 0078 	uint32_t ans = 0;
; 0004 0079 	//lcd_clear();
; 0004 007A 	//lcd_putsf("Place your finger.");
; 0004 007B 	setCmosLED(1);
	RCALL SUBOPT_0x27
	RCALL SUBOPT_0x28
;	ans -> Y+0
	RCALL SUBOPT_0x7
; 0004 007C 	while (!fingerPressed());
_0x8001C:
	RCALL SUBOPT_0x8
	BREQ _0x8001C
; 0004 007D 	ans = FPS_getInt(Identify1_N);
	__GETD2N 0x51
	RCALL _FPS_getInt
	RCALL SUBOPT_0x4B
; 0004 007E 	setCmosLED(0);
	LDI  R26,LOW(0)
	RCALL _setCmosLED
; 0004 007F 	if (rxPacket[10] == Nack)
	RCALL SUBOPT_0x4D
	BRNE _0x8001F
; 0004 0080 	{
; 0004 0081 	    lcd_clear();
	RCALL _lcd_clear
; 0004 0082 	    lcd_putsf("Failed");
	__POINTW2FN _0x80000,0
	RCALL _lcd_putsf
; 0004 0083 		return 21;
	LDI  R30,LOW(21)
	RJMP _0x20C000B
; 0004 0084 	}
; 0004 0085 	return ans;
_0x8001F:
	LD   R30,Y
_0x20C000B:
	ADIW R28,4
	RET
; 0004 0086 }
;uint8_t deleteAllIds(void)
; 0004 0088 {
; 0004 0089 	uint32_t ans = 0;
; 0004 008A 
; 0004 008B 	ans = FPS_getInt(DeleteAll);
;	ans -> Y+0
; 0004 008C 
; 0004 008D     if (rxPacket[10] == Nack)
; 0004 008E 	{
; 0004 008F 	    lcd_clear();
; 0004 0090 	    lcd_putsf("Failed");
; 0004 0091 		return 21;
; 0004 0092 	}
; 0004 0093 	return ans;
; 0004 0094 }
;
;uint8_t getAFreeId(void)
; 0004 0097 {
_getAFreeId:
; 0004 0098 	uint8_t i = 0;
; 0004 0099 	for (i = 0; i < 8; i++)
	ST   -Y,R17
;	i -> R17
	LDI  R17,0
	LDI  R17,LOW(0)
_0x80022:
	CPI  R17,8
	BRSH _0x80023
; 0004 009A 	{
; 0004 009B 		if (!isEnrolled(i))
	MOV  R26,R17
	RCALL _isEnrolled
	CPI  R30,0
	BRNE _0x80024
; 0004 009C 			return i;
	RJMP _0x20C0009
; 0004 009D 	}
_0x80024:
	SUBI R17,-1
	RJMP _0x80022
_0x80023:
; 0004 009E 	return i;
	RJMP _0x20C0009
; 0004 009F }
;uint8_t enrollAFinger(uint8_t id)
; 0004 00A1 {
_enrollAFinger:
; 0004 00A2 	lcd_clear();
	ST   -Y,R26
;	id -> Y+0
	RCALL _lcd_clear
; 0004 00A3     bips(4);
	LDI  R26,LOW(4)
	RCALL _bips
; 0004 00A4 	lcd_putsf("Place finger ");
	RCALL SUBOPT_0x4E
; 0004 00A5     lcd_gotoxy(0,1);
; 0004 00A6     lcd_putsf("(1/3)");
	__POINTW2FN _0x80000,21
	RCALL SUBOPT_0x1
; 0004 00A7     delay_ms(1000);
; 0004 00A8 	setCmosLED(1);
	RCALL SUBOPT_0x7
; 0004 00A9 	while (!fingerPressed()) {if (cancel_PB is pressed) return 2;}
_0x80025:
	RCALL SUBOPT_0x8
	BRNE _0x80027
	SBIC 0x10,5
	RJMP _0x80028
	LDI  R30,LOW(2)
	RJMP _0x20C0001
_0x80028:
	RJMP _0x80025
_0x80027:
; 0004 00AA 	delay_ms(1000);
	RCALL SUBOPT_0xB
; 0004 00AB 
; 0004 00AC 	getCommand(EnrollStart, id);
	LDI  R30,LOW(34)
	LDI  R31,HIGH(34)
	RCALL SUBOPT_0x45
	RCALL SUBOPT_0x46
; 0004 00AD 	getCommand(Enroll1, 0);
	LDI  R30,LOW(35)
	LDI  R31,HIGH(35)
	RCALL SUBOPT_0x49
; 0004 00AE 	if (rxPacket[10] == Nack)
	RCALL SUBOPT_0x4D
	BRNE _0x80029
; 0004 00AF 	{
; 0004 00B0 	    lcd_clear();
	RCALL _lcd_clear
; 0004 00B1 	    lcd_putsf("Failed. ");
	__POINTW2FN _0x80000,27
	RCALL SUBOPT_0x0
; 0004 00B2         lcd_gotoxy(0,1);
; 0004 00B3         lcd_putsf("Reseting FPS.");
	__POINTW2FN _0x80000,36
	RCALL SUBOPT_0x4F
; 0004 00B4 		FPS_reset();
; 0004 00B5 		return 0;
	RJMP _0x20C0001
; 0004 00B6 	}
; 0004 00B7     delay_ms(1000);
_0x80029:
	RCALL SUBOPT_0xB
; 0004 00B8 	lcd_clear();
	RCALL SUBOPT_0x50
; 0004 00B9 
; 0004 00BA 	lcd_putsf("Take of the ");
; 0004 00BB     lcd_gotoxy(0,1);
; 0004 00BC     lcd_putsf("finger.");
	RCALL SUBOPT_0x51
; 0004 00BD     soundOK();
; 0004 00BE 	while (fingerPressed()){if (cancel_PB is pressed) return 2;}
_0x8002A:
	RCALL SUBOPT_0x8
	BREQ _0x8002C
	SBIC 0x10,5
	RJMP _0x8002D
	LDI  R30,LOW(2)
	RJMP _0x20C0001
_0x8002D:
	RJMP _0x8002A
_0x8002C:
; 0004 00BF 
; 0004 00C0 
; 0004 00C1 	lcd_clear();
	RCALL _lcd_clear
; 0004 00C2     bip();
	RCALL _bip
; 0004 00C3 	lcd_putsf("Place finger ");
	RCALL SUBOPT_0x4E
; 0004 00C4     lcd_gotoxy(0,1);
; 0004 00C5     lcd_putsf("(2/3)");
	__POINTW2FN _0x80000,71
	RCALL SUBOPT_0x1
; 0004 00C6     delay_ms(1000);
; 0004 00C7 	while (!fingerPressed()) {if (cancel_PB is pressed) return 2;}
_0x8002E:
	RCALL SUBOPT_0x8
	BRNE _0x80030
	SBIC 0x10,5
	RJMP _0x80031
	LDI  R30,LOW(2)
	RJMP _0x20C0001
_0x80031:
	RJMP _0x8002E
_0x80030:
; 0004 00C8 	delay_ms(1000);
	RCALL SUBOPT_0xB
; 0004 00C9 
; 0004 00CA 	getCommand(Enroll2, 0);
	LDI  R30,LOW(36)
	LDI  R31,HIGH(36)
	RCALL SUBOPT_0x49
; 0004 00CB 	if (rxPacket[10] == Nack)
	RCALL SUBOPT_0x4D
	BRNE _0x80032
; 0004 00CC 	{
; 0004 00CD 	    lcd_clear();
	RCALL SUBOPT_0x52
; 0004 00CE 	    lcd_putsf("Failed. Reseting ");
; 0004 00CF         lcd_gotoxy(0,1);
; 0004 00D0         lcd_putsf("FPS.");
	__POINTW2FN _0x80000,45
	RCALL SUBOPT_0x4F
; 0004 00D1 		FPS_reset();
; 0004 00D2 		return 0;
	RJMP _0x20C0001
; 0004 00D3 	}
; 0004 00D4     delay_ms(1000);
_0x80032:
	RCALL SUBOPT_0xB
; 0004 00D5 	lcd_clear();
	RCALL SUBOPT_0x50
; 0004 00D6 	lcd_putsf("Take of the ");
; 0004 00D7     lcd_gotoxy(0,1);
; 0004 00D8     lcd_putsf("finger.");
	RCALL SUBOPT_0x51
; 0004 00D9     soundOK();
; 0004 00DA 	while (fingerPressed()){if (cancel_PB is pressed) return 2;}
_0x80033:
	RCALL SUBOPT_0x8
	BREQ _0x80035
	SBIC 0x10,5
	RJMP _0x80036
	LDI  R30,LOW(2)
	RJMP _0x20C0001
_0x80036:
	RJMP _0x80033
_0x80035:
; 0004 00DB 
; 0004 00DC 	lcd_clear();
	RCALL _lcd_clear
; 0004 00DD     bip();
	RCALL _bip
; 0004 00DE 	lcd_putsf("Place finger ");
	RCALL SUBOPT_0x4E
; 0004 00DF     lcd_gotoxy(0,1);
; 0004 00E0     lcd_putsf("(3/3)");
	__POINTW2FN _0x80000,95
	RCALL SUBOPT_0xD
; 0004 00E1     delay_ms(2000);
; 0004 00E2 	while (!fingerPressed()) {if (cancel_PB is pressed) return 2;}
_0x80037:
	RCALL SUBOPT_0x8
	BRNE _0x80039
	SBIC 0x10,5
	RJMP _0x8003A
	LDI  R30,LOW(2)
	RJMP _0x20C0001
_0x8003A:
	RJMP _0x80037
_0x80039:
; 0004 00E3 	delay_ms(1000);
	RCALL SUBOPT_0xB
; 0004 00E4 
; 0004 00E5 	getCommand(Enroll3, 0);
	LDI  R30,LOW(37)
	LDI  R31,HIGH(37)
	RCALL SUBOPT_0x49
; 0004 00E6 	if (rxPacket[10] == Nack)
	RCALL SUBOPT_0x4D
	BRNE _0x8003B
; 0004 00E7 	{
; 0004 00E8 	    lcd_clear();
	RCALL SUBOPT_0x52
; 0004 00E9 	    lcd_putsf("Failed. Reseting ");
; 0004 00EA         lcd_gotoxy(0,1);
; 0004 00EB         lcd_putsf("FPS.");
	__POINTW2FN _0x80000,45
	RCALL SUBOPT_0x4F
; 0004 00EC 		FPS_reset();
; 0004 00ED 		return 0;
	RJMP _0x20C0001
; 0004 00EE 	}
; 0004 00EF     delay_ms(1000);
_0x8003B:
	RCALL SUBOPT_0xB
; 0004 00F0 	lcd_clear();
	RCALL SUBOPT_0x50
; 0004 00F1 	lcd_putsf("Take of the ");
; 0004 00F2     lcd_gotoxy(0,1);
; 0004 00F3     lcd_putsf("finger.");
	RCALL SUBOPT_0x51
; 0004 00F4     soundOK();
; 0004 00F5 	while (fingerPressed()){if (cancel_PB is pressed) return 2;}
_0x8003C:
	RCALL SUBOPT_0x8
	BREQ _0x8003E
	SBIC 0x10,5
	RJMP _0x8003F
	LDI  R30,LOW(2)
	RJMP _0x20C0001
_0x8003F:
	RJMP _0x8003C
_0x8003E:
; 0004 00F6 	setCmosLED(0);
	LDI  R26,LOW(0)
	RCALL _setCmosLED
; 0004 00F7 	lcd_clear();
	RCALL _lcd_clear
; 0004 00F8 	lcd_putsf("Enrollment ");
	__POINTW2FN _0x80000,101
	RCALL _lcd_putsf
; 0004 00F9     delay_ms(500);
	RCALL SUBOPT_0x24
; 0004 00FA 	return 1;
	LDI  R30,LOW(1)
	RJMP _0x20C0001
; 0004 00FB }
;#include <delay.h>
;#include <mega8.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;#include "projDefines.h"
;#include "projHeaders.h"
;#include <math.h>
;
;unsigned char getProximity()
; 0005 0008 {

	.CSEG
_getProximity:
; 0005 0009     char i = 0;
; 0005 000A //    IRLED be iON;
; 0005 000B     delay_ms(1);
	ST   -Y,R17
;	i -> R17
	LDI  R17,0
	LDI  R26,LOW(1)
	RCALL SUBOPT_0x53
; 0005 000C     i = IRD;
	LDI  R30,0
	SBIC 0x10,3
	LDI  R30,1
	MOV  R17,R30
; 0005 000D //    IRLED be iOFF;
; 0005 000E     return i;
_0x20C0009:
	MOV  R30,R17
_0x20C000A:
	LD   R17,Y+
	RET
; 0005 000F }
;eeprom char resetByWDT;
;void controllerReset(void)
; 0005 0012 {
_controllerReset:
; 0005 0013     resetByWDT = 0;
	LDI  R26,LOW(_resetByWDT)
	LDI  R27,HIGH(_resetByWDT)
	LDI  R30,LOW(0)
	RCALL __EEPROMWRB
; 0005 0014     TIMSK = 0;
	OUT  0x39,R30
; 0005 0015     while(1);
_0xA0003:
	RJMP _0xA0003
; 0005 0016 }
;void lockMotorRoutine(void)
; 0005 0018 {
_lockMotorRoutine:
; 0005 0019     fpsCount ++;
	LDI  R26,LOW(_fpsCount)
	LDI  R27,HIGH(_fpsCount)
	RCALL __EEPROMRDW
	ADIW R30,1
	RCALL __EEPROMWRW
	SBIW R30,1
; 0005 001A     if (mV < 4000)
	RCALL SUBOPT_0x19
	CPI  R26,LOW(0xFA0)
	LDI  R30,HIGH(0xFA0)
	CPC  R27,R30
	BRGE _0xA0006
; 0005 001B         soundBatteryLow();
	RCALL _soundBatteryLow
; 0005 001C     else
	RJMP _0xA0007
_0xA0006:
; 0005 001D     {
; 0005 001E         resetByWDT = 1;
	LDI  R26,LOW(_resetByWDT)
	LDI  R27,HIGH(_resetByWDT)
	LDI  R30,LOW(1)
	RCALL __EEPROMWRB
; 0005 001F         TIMSK &= ~0x01;
	IN   R30,0x39
	ANDI R30,0xFE
	OUT  0x39,R30
; 0005 0020         OCR2 = 249;
	LDI  R30,LOW(249)
	OUT  0x23,R30
; 0005 0021         lockMotor be ON;
	SBI  0x18,7
; 0005 0022         delay_ms(1500);
	LDI  R26,LOW(1500)
	LDI  R27,HIGH(1500)
	RCALL _delay_ms
; 0005 0023         lockMotor be OFF;
	CBI  0x18,7
; 0005 0024         TIMSK |= 0x01;
	IN   R30,0x39
	ORI  R30,1
	OUT  0x39,R30
; 0005 0025         #asm("WDR")
	WDR
; 0005 0026     }
_0xA0007:
; 0005 0027 }
	RET
;void soundBatteryLow(void)
; 0005 0029 {
_soundBatteryLow:
; 0005 002A     beepSwipe(900, 300, 200);
	LDI  R30,LOW(900)
	LDI  R31,HIGH(900)
	RCALL SUBOPT_0x54
; 0005 002B     delay_ms(100);
; 0005 002C     beepSwipe(3000, 300, 200);
	RCALL SUBOPT_0x55
	RCALL SUBOPT_0x54
; 0005 002D     delay_ms(100);
; 0005 002E     beepSwipe(3000, 300, 200);
	RCALL SUBOPT_0x56
	LDI  R30,LOW(300)
	LDI  R31,HIGH(300)
	RJMP _0x20C0007
; 0005 002F }
;void soundPowerFailure(void)
; 0005 0031 {
; 0005 0032     beepSwipe(900, 300, 200);
; 0005 0033     beep(300, 500);
; 0005 0034 }
;
;void soundPowerOverFlow(void)
; 0005 0037 {
; 0005 0038     beepSwipe(400, 800, 500);
; 0005 0039 }
;
;void soundOK(void)
; 0005 003C {
_soundOK:
; 0005 003D     beepSwipe(400 , 3000, 200);
	RCALL SUBOPT_0x57
	RCALL SUBOPT_0x55
	RJMP _0x20C0007
; 0005 003E }
;void soundQuestion(void)
; 0005 0040 {
_soundQuestion:
; 0005 0041     beepSwipe(400,400, 500);
	RCALL SUBOPT_0x57
	RCALL SUBOPT_0x57
	LDI  R26,LOW(500)
	LDI  R27,HIGH(500)
	RJMP _0x20C0006
; 0005 0042 }
;void soundAlarm(void)
; 0005 0044 {
_soundAlarm:
; 0005 0045     buzzer be ON;
	SBI  0x18,1
; 0005 0046     delay_ms(500);
	RCALL SUBOPT_0x24
; 0005 0047     buzzer be OFF;
	CBI  0x18,1
; 0005 0048     delay_ms(300);
	LDI  R26,LOW(300)
	LDI  R27,HIGH(300)
_0x20C0008:
	RCALL _delay_ms
; 0005 0049 }
	RET
;void soundSuccess(void)
; 0005 004B {
_soundSuccess:
; 0005 004C     beep(400,70);
	RCALL SUBOPT_0x57
	LDI  R26,LOW(70)
	RCALL SUBOPT_0x41
	RCALL _beep
; 0005 004D     delay_ms(100);
	RCALL SUBOPT_0x3F
; 0005 004E     beep(400,750);
	RCALL SUBOPT_0x57
	LDI  R26,LOW(750)
	LDI  R27,HIGH(750)
	RCALL _beep
; 0005 004F     beepSwipe(400, 3000, 250);
	RCALL SUBOPT_0x57
	RCALL SUBOPT_0x56
	LDI  R26,LOW(250)
	RJMP _0x20C0005
; 0005 0050 }
;void soundError(void)
; 0005 0052 {
_soundError:
; 0005 0053     beepSwipe(3000 , 400, 200);
	RCALL SUBOPT_0x56
	RCALL SUBOPT_0x57
	LDI  R26,LOW(200)
	RCALL SUBOPT_0x41
	RCALL _beepSwipe
; 0005 0054     beepSwipe(3000 , 400, 200);
; 0005 0055 }
;void soundCancel(void)
; 0005 0057 {
_soundCancel:
; 0005 0058     beepSwipe(3000 , 400, 200);
_0x20C0004:
	LDI  R30,LOW(3000)
	LDI  R31,HIGH(3000)
	RCALL SUBOPT_0x45
	LDI  R30,LOW(400)
	LDI  R31,HIGH(400)
_0x20C0007:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(200)
_0x20C0005:
	LDI  R27,0
_0x20C0006:
	RCALL _beepSwipe
; 0005 0059 }
	RET
;
;void bips(unsigned char count)
; 0005 005C {
_bips:
; 0005 005D     while (count > 0)
	ST   -Y,R26
;	count -> Y+0
_0xA0010:
	LD   R26,Y
	CPI  R26,LOW(0x1)
	BRLO _0xA0012
; 0005 005E     {
; 0005 005F         buzzer be ON;
	SBI  0x18,1
; 0005 0060         delay_ms(75);
	LDI  R26,LOW(75)
	RCALL SUBOPT_0x53
; 0005 0061         buzzer be OFF;
	CBI  0x18,1
; 0005 0062         delay_ms(75);
	LDI  R26,LOW(75)
	RCALL SUBOPT_0x53
; 0005 0063         count --;
	LD   R30,Y
	SUBI R30,LOW(1)
	ST   Y,R30
; 0005 0064     }
	RJMP _0xA0010
_0xA0012:
; 0005 0065 }
	RJMP _0x20C0001
;void bip(void)
; 0005 0067 {
_bip:
; 0005 0068     buzzer be ON;
	SBI  0x18,1
; 0005 0069     delay_ms(100);
	RCALL SUBOPT_0x3F
; 0005 006A     buzzer be OFF;
	CBI  0x18,1
; 0005 006B }
	RET
;void soundTick(void)
; 0005 006D {
_soundTick:
; 0005 006E     beep(300, 50);
	LDI  R30,LOW(300)
	LDI  R31,HIGH(300)
	RCALL SUBOPT_0x45
	LDI  R26,LOW(50)
	RCALL SUBOPT_0x41
	RCALL _beep
; 0005 006F     delay_ms(20);
	LDI  R26,LOW(20)
	RCALL SUBOPT_0x53
; 0005 0070     beep(3000,50);
	RCALL SUBOPT_0x56
	LDI  R26,LOW(50)
	RCALL SUBOPT_0x41
	RCALL _beep
; 0005 0071 }
	RET
;void delay_ms_v(int ms)
; 0005 0073 {
_delay_ms_v:
; 0005 0074     while(ms > 0)
	RCALL SUBOPT_0x58
;	ms -> Y+0
_0xA001B:
	LD   R26,Y
	LDD  R27,Y+1
	RCALL __CPW02
	BRGE _0xA001D
; 0005 0075     {
; 0005 0076         delay_us(998);
	__DELAY_USW 1996
; 0005 0077         ms--;
	LD   R30,Y
	LDD  R31,Y+1
	SBIW R30,1
	ST   Y,R30
	STD  Y+1,R31
; 0005 0078     }
	RJMP _0xA001B
_0xA001D:
; 0005 0079 
; 0005 007A }
	RJMP _0x20C0002
;void beep(unsigned int f_khz, unsigned int period_ms)
; 0005 007C {
_beep:
; 0005 007D     float tp = 0;
; 0005 007E     f_khz = min(f_khz, 12600);
	RCALL SUBOPT_0x58
	RCALL SUBOPT_0x27
	RCALL SUBOPT_0x28
;	f_khz -> Y+6
;	period_ms -> Y+4
;	tp -> Y+0
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	RCALL SUBOPT_0x45
	LDI  R26,LOW(12600)
	LDI  R27,HIGH(12600)
	RCALL _min
	RCALL SUBOPT_0x59
; 0005 007F     f_khz = max(f_khz, 260);
	RCALL SUBOPT_0x45
	LDI  R26,LOW(260)
	LDI  R27,HIGH(260)
	RCALL _max
	RCALL SUBOPT_0x59
; 0005 0080     tp = (float)1000000 / (float)f_khz; // tp in us
	CLR  R22
	CLR  R23
	RCALL __CDF1
	__GETD2N 0x49742400
	RCALL __DIVF21
	RCALL SUBOPT_0x4B
; 0005 0081     //now, if ICR = 8, tp = 1us, 16 for 2us
; 0005 0082     TCCR1A=0x82;
	LDI  R30,LOW(130)
	OUT  0x2F,R30
; 0005 0083     TCCR1B=0x19;
	LDI  R30,LOW(25)
	OUT  0x2E,R30
; 0005 0084     ICR1 = max((int)tp * 8 , 600);
	RCALL SUBOPT_0x4A
	RCALL __CFD1
	RCALL __LSLW3
	RCALL SUBOPT_0x45
	LDI  R26,LOW(600)
	LDI  R27,HIGH(600)
	RCALL _max
	OUT  0x26+1,R31
	OUT  0x26,R30
; 0005 0085     OCR1A = 400;
	LDI  R30,LOW(400)
	LDI  R31,HIGH(400)
	OUT  0x2A+1,R31
	OUT  0x2A,R30
; 0005 0086     delay_ms_v(period_ms);
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	RCALL _delay_ms_v
; 0005 0087     TCCR1A=0;
	LDI  R30,LOW(0)
	OUT  0x2F,R30
; 0005 0088     TCCR1B=0;
	OUT  0x2E,R30
; 0005 0089     ICR1 = 0;
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	OUT  0x26+1,R31
	OUT  0x26,R30
; 0005 008A     buzzer be OFF;
	CBI  0x18,1
; 0005 008B }
	ADIW R28,8
	RET
;void beepSwipe(unsigned int f_khz1, unsigned int f_khz2, unsigned int period_ms)
; 0005 008D {
_beepSwipe:
; 0005 008E     signed char i = 0, steps = 50;
; 0005 008F     signed int inc = ((signed int)f_khz2 - (signed int)f_khz1) / steps;
; 0005 0090     for (i = 0; i < steps; i++)
	RCALL SUBOPT_0x58
	RCALL __SAVELOCR4
;	f_khz1 -> Y+8
;	f_khz2 -> Y+6
;	period_ms -> Y+4
;	i -> R17
;	steps -> R16
;	inc -> R18,R19
	LDI  R17,0
	LDI  R16,50
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	SUB  R30,R26
	SBC  R31,R27
	MOVW R26,R30
	RCALL SUBOPT_0x5A
	RCALL __DIVW21
	MOVW R18,R30
	LDI  R17,LOW(0)
_0xA0021:
	CP   R17,R16
	BRGE _0xA0022
; 0005 0091         beep(f_khz1 +  (signed int)(i * inc), period_ms / steps);
	MOV  R26,R17
	LDI  R27,0
	SBRC R26,7
	SER  R27
	MOVW R30,R18
	RCALL __MULW12
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	ADD  R30,R26
	ADC  R31,R27
	RCALL SUBOPT_0x45
	RCALL SUBOPT_0x5A
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	RCALL __DIVW21U
	MOVW R26,R30
	RCALL _beep
	SUBI R17,-1
	RJMP _0xA0021
_0xA0022:
; 0005 0092 }
	RCALL __LOADLOCR4
	ADIW R28,10
	RET
;#include <alcd.h>
;void define_char(unsigned char flash *pc,unsigned char char_code)
; 0006 0003 {

	.CSEG
_define_char:
; 0006 0004     unsigned char i,address;
; 0006 0005     address=(char_code<<3)|0x40;
	ST   -Y,R26
	RCALL __SAVELOCR2
;	*pc -> Y+3
;	char_code -> Y+2
;	i -> R17
;	address -> R16
	LDD  R30,Y+2
	LSL  R30
	LSL  R30
	LSL  R30
	ORI  R30,0x40
	MOV  R16,R30
; 0006 0006     for (i=0; i<8; i++) lcd_write_byte(address++,*pc++);
	LDI  R17,LOW(0)
_0xC0004:
	CPI  R17,8
	BRSH _0xC0005
	ST   -Y,R16
	INC  R16
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	ADIW R30,1
	STD  Y+4,R30
	STD  Y+4+1,R31
	SBIW R30,1
	LPM  R26,Z
	RCALL _lcd_write_byte
	SUBI R17,-1
	RJMP _0xC0004
_0xC0005:
; 0006 0007 }
	RCALL __LOADLOCR2
	ADIW R28,5
	RET
;flash unsigned char fingerPrint_charTable[8]=
;{
;	0b1001110,
;	0b1010001,
;	0b1010101,
;	0b1010100,
;	0b1010111,
;	0b1010000,
;	0b1001111,
;	0b11000000};
;
;void init_fingerPrint_char(void)
; 0006 0014 {
_init_fingerPrint_char:
; 0006 0015 	define_char(fingerPrint_charTable, 0);
	LDI  R30,LOW(_fingerPrint_charTable*2)
	LDI  R31,HIGH(_fingerPrint_charTable*2)
	RCALL SUBOPT_0x45
	LDI  R26,LOW(0)
	RJMP _0x20C0003
; 0006 0016 }
;
;flash unsigned char power_charTable[8]=
;{
;    0b1000010,
;    0b1000100,
;    0b1001000,
;    0b1001110,
;    0b1000010,
;    0b1000100,
;    0b1001000,
;    0b11000000};
;
;void init_power_char(void)
; 0006 0024 {
; 0006 0025     define_char(power_charTable, 1);
; 0006 0026 }
;
;flash unsigned char battery_charTable[8]=
;{
;    0b1001110,
;    0b1010001,
;    0b1010001,
;    0b1011111,
;    0b1011111,
;    0b1011111,
;    0b1011111,
;    0b11000000};
;
;void init_battery_char(void)
; 0006 0034 {
_init_battery_char:
; 0006 0035     define_char(battery_charTable, 2);
	LDI  R30,LOW(_battery_charTable*2)
	LDI  R31,HIGH(_battery_charTable*2)
	RCALL SUBOPT_0x45
	LDI  R26,LOW(2)
	RJMP _0x20C0003
; 0006 0036 }
;
;flash unsigned char switch_charTable[8]=
;{
;    0b1000010,
;    0b1001001,
;    0b1000110,
;    0b1000001,
;    0b1000110,
;    0b1001000,
;    0b1000100,
;    0b11000000};
;
;void init_switch_char(void)
; 0006 0044 {
_init_switch_char:
; 0006 0045     define_char(switch_charTable, 3);
	LDI  R30,LOW(_switch_charTable*2)
	LDI  R31,HIGH(_switch_charTable*2)
	RCALL SUBOPT_0x45
	LDI  R26,LOW(3)
	RJMP _0x20C0003
; 0006 0046 }
;
;flash unsigned char locked_charTable[8]=
;{
;    0b1001110,
;    0b1010001,
;    0b1010001,
;    0b1011111,
;    0b1011011,
;    0b1011011,
;    0b1011111,
;    0b11000000};
;
;void init_locked_char(void)
; 0006 0054 {
_init_locked_char:
; 0006 0055     define_char(locked_charTable, 4);
	LDI  R30,LOW(_locked_charTable*2)
	LDI  R31,HIGH(_locked_charTable*2)
	RCALL SUBOPT_0x45
	LDI  R26,LOW(4)
	RJMP _0x20C0003
; 0006 0056 }
;
;flash unsigned char unlocked_charTable[8]=
;{
;    0b1001110,
;    0b1010000,
;    0b1010000,
;    0b1011110,
;    0b1011011,
;    0b1011011,
;    0b1011111,
;    0b11000000};
;
;void init_unlocked_char(void)
; 0006 0064 {
_init_unlocked_char:
; 0006 0065     define_char(unlocked_charTable, 5);
	LDI  R30,LOW(_unlocked_charTable*2)
	LDI  R31,HIGH(_unlocked_charTable*2)
	RCALL SUBOPT_0x45
	LDI  R26,LOW(5)
	RJMP _0x20C0003
; 0006 0066 }
;
;flash unsigned char smilie_charTable[8]=
;{
;    0b1000000,
;    0b1001010,
;    0b1000000,
;    0b1000000,
;    0b1010001,
;    0b1001110,
;    0b1000000,
;    0b11000000};
;
;void init_smilie_char(void)
; 0006 0074 {
_init_smilie_char:
; 0006 0075     define_char(smilie_charTable, 6);
	LDI  R30,LOW(_smilie_charTable*2)
	LDI  R31,HIGH(_smilie_charTable*2)
	RCALL SUBOPT_0x45
	LDI  R26,LOW(6)
_0x20C0003:
	RCALL _define_char
; 0006 0076 }
	RET
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.DSEG

	.CSEG
__lcd_write_nibble_G101:
	ST   -Y,R26
	LD   R30,Y
	ANDI R30,LOW(0x10)
	BREQ _0x2020004
	SBI  0x15,2
	RJMP _0x2020005
_0x2020004:
	CBI  0x15,2
_0x2020005:
	LD   R30,Y
	ANDI R30,LOW(0x20)
	BREQ _0x2020006
	SBI  0x15,3
	RJMP _0x2020007
_0x2020006:
	CBI  0x15,3
_0x2020007:
	LD   R30,Y
	ANDI R30,LOW(0x40)
	BREQ _0x2020008
	SBI  0x15,4
	RJMP _0x2020009
_0x2020008:
	CBI  0x15,4
_0x2020009:
	LD   R30,Y
	ANDI R30,LOW(0x80)
	BREQ _0x202000A
	SBI  0x15,5
	RJMP _0x202000B
_0x202000A:
	CBI  0x15,5
_0x202000B:
	__DELAY_USB 5
	SBI  0x15,1
	__DELAY_USB 13
	CBI  0x15,1
	__DELAY_USB 13
	RJMP _0x20C0001
__lcd_write_data:
	ST   -Y,R26
	LD   R26,Y
	RCALL __lcd_write_nibble_G101
    ld    r30,y
    swap  r30
    st    y,r30
	LD   R26,Y
	RCALL __lcd_write_nibble_G101
	__DELAY_USB 133
	RJMP _0x20C0001
_lcd_write_byte:
	ST   -Y,R26
	LDD  R26,Y+1
	RCALL __lcd_write_data
	RCALL SUBOPT_0x5B
	RJMP _0x20C0002
_lcd_gotoxy:
	ST   -Y,R26
	LD   R30,Y
	RCALL SUBOPT_0x11
	SUBI R30,LOW(-__base_y_G101)
	SBCI R31,HIGH(-__base_y_G101)
	LD   R30,Z
	LDD  R26,Y+1
	ADD  R26,R30
	RCALL __lcd_write_data
	LDD  R12,Y+1
	LD   R30,Y
	STS  __lcd_y,R30
_0x20C0002:
	ADIW R28,2
	RET
_lcd_clear:
	LDI  R26,LOW(2)
	RCALL __lcd_write_data
	LDI  R26,LOW(3)
	RCALL SUBOPT_0x53
	LDI  R26,LOW(12)
	RCALL __lcd_write_data
	LDI  R26,LOW(1)
	RCALL __lcd_write_data
	LDI  R26,LOW(3)
	RCALL SUBOPT_0x53
	LDI  R30,LOW(0)
	STS  __lcd_y,R30
	MOV  R12,R30
	RET
_lcd_putchar:
	ST   -Y,R26
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BREQ _0x2020011
	LDS  R30,__lcd_maxx
	CP   R12,R30
	BRLO _0x2020010
_0x2020011:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDS  R26,__lcd_y
	SUBI R26,-LOW(1)
	STS  __lcd_y,R26
	RCALL _lcd_gotoxy
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BRNE _0x2020013
	RJMP _0x20C0001
_0x2020013:
_0x2020010:
	INC  R12
	RCALL SUBOPT_0x5B
	RJMP _0x20C0001
_lcd_putsf:
	RCALL SUBOPT_0x58
	ST   -Y,R17
_0x2020017:
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ADIW R30,1
	STD  Y+1,R30
	STD  Y+1+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x2020019
	MOV  R26,R17
	RCALL _lcd_putchar
	RJMP _0x2020017
_0x2020019:
	LDD  R17,Y+0
	ADIW R28,3
	RET
_lcd_init:
	ST   -Y,R26
	SBI  0x14,2
	SBI  0x14,3
	SBI  0x14,4
	SBI  0x14,5
	SBI  0x14,1
	SBI  0x17,4
	SBI  0x17,5
	CBI  0x15,1
	CBI  0x18,4
	CBI  0x18,5
	LD   R30,Y
	STS  __lcd_maxx,R30
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G101,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G101,3
	LDI  R26,LOW(20)
	RCALL SUBOPT_0x53
	RCALL SUBOPT_0x5C
	RCALL SUBOPT_0x5C
	RCALL SUBOPT_0x5C
	LDI  R26,LOW(32)
	RCALL __lcd_write_nibble_G101
	__DELAY_USW 200
	LDI  R26,LOW(40)
	RCALL __lcd_write_data
	LDI  R26,LOW(4)
	RCALL __lcd_write_data
	LDI  R26,LOW(133)
	RCALL __lcd_write_data
	LDI  R26,LOW(6)
	RCALL __lcd_write_data
	RCALL _lcd_clear
_0x20C0001:
	ADIW R28,1
	RET

	.CSEG
_abs:
	RCALL SUBOPT_0x58
    ld   r30,y+
    ld   r31,y+
    sbiw r30,0
    brpl __abs0
    com  r30
    com  r31
    adiw r30,1
__abs0:
    ret

	.DSEG

	.CSEG

	.CSEG

	.CSEG
_max:
	RCALL SUBOPT_0x58
    ld   r26,y+
    ld   r27,y+
    ld   r30,y+
    ld   r31,y+
    cp   r26,r30
    cpc  r27,r31
    brlt __max0
    movw r30,r26
__max0:
    ret
_min:
	RCALL SUBOPT_0x58
    ld   r26,y+
    ld   r27,y+
    ld   r30,y+
    ld   r31,y+
    cp   r30,r26
    cpc  r31,r27
    brlt __min0
    movw r30,r26
__min0:
    ret

	.CSEG

	.DSEG
_rx_counter:
	.BYTE 0x1
_mV:
	.BYTE 0x2
_cpuHaltAllowed:
	.BYTE 0x1
_powerMode:
	.BYTE 0x1

	.ESEG
_resetByWDT:
	.BYTE 0x1
_failedCount:
	.BYTE 0x1

	.DSEG
_junkFreeTimer:
	.BYTE 0x1
_autoSleepTimer:
	.BYTE 0x1
_dontWDR:
	.BYTE 0x1

	.ESEG
_fpsCount:
	.BYTE 0x2

	.DSEG
_elapsed_sec:
	.BYTE 0x2

	.ESEG
_securityMethod:
	.BYTE 0x1

	.DSEG
_rx_buffer:
	.BYTE 0x10
_tx_buffer:
	.BYTE 0x10
_elapsed_us:
	.BYTE 0x2
_elapsed_ms:
	.BYTE 0x2
_txPacket:
	.BYTE 0xC
_rxPacket:
	.BYTE 0xC
__base_y_G101:
	.BYTE 0x4
__lcd_y:
	.BYTE 0x1
__lcd_maxx:
	.BYTE 0x1
__seed_G102:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 15 TIMES, CODE SIZE REDUCTION:54 WORDS
SUBOPT_0x0:
	RCALL _lcd_putsf
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(1)
	RJMP _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x1:
	RCALL _lcd_putsf
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	RJMP _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2:
	LDI  R30,LOW(3)
	ST   -Y,R30
	LDI  R26,LOW(0)
	RCALL _getIdFinally
	MOV  R17,R30
	CPI  R17,8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3:
	LDD  R30,Y+4
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4:
	SBI  0x12,2
	RJMP _FPS_open

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x5:
	LDI  R26,LOW(_failedCount)
	LDI  R27,HIGH(_failedCount)
	RCALL __EEPROMRDB
	CPI  R30,LOW(0x5)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x6:
	LDI  R26,LOW(_failedCount)
	LDI  R27,HIGH(_failedCount)
	LDI  R30,LOW(0)
	RCALL __EEPROMWRB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x7:
	LDI  R26,LOW(1)
	RJMP _setCmosLED

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x8:
	RCALL _fingerPressed
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x9:
	LDI  R26,0
	SBIC 0x10,5
	LDI  R26,1
	CPI  R26,LOW(0x0)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xA:
	RCALL _lcd_putsf
	MOV  R26,R16
	SUBI R26,-LOW(48)
	RJMP _lcd_putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:16 WORDS
SUBOPT_0xB:
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	RJMP _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xC:
	RCALL __EEPROMRDB
	SUBI R30,-LOW(1)
	RCALL __EEPROMWRB
	SUBI R30,LOW(1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xD:
	RCALL _lcd_putsf
	LDI  R26,LOW(2000)
	LDI  R27,HIGH(2000)
	RJMP _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xE:
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xF:
	RCALL _lcd_putsf
	MOV  R26,R17
	SUBI R26,-LOW(48)
	RCALL _lcd_putchar
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(1)
	RCALL _lcd_gotoxy
	__POINTW2FN _0x0,118
	RCALL _lcd_putsf
	LDI  R30,LOW(8)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x10:
	SUBI R30,-LOW(48)
	MOV  R26,R30
	RCALL _lcd_putchar
	LDI  R26,LOW(2000)
	LDI  R27,HIGH(2000)
	RJMP _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 20 TIMES, CODE SIZE REDUCTION:36 WORDS
SUBOPT_0x11:
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x12:
	LDI  R26,0
	SBIC 0x10,7
	LDI  R26,1
	CPI  R26,LOW(0x0)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x13:
	LDI  R30,LOW(0)
	STD  Y+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x14:
	LDS  R26,_elapsed_sec
	LDS  R27,_elapsed_sec+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x15:
	RCALL SUBOPT_0xE
	RCALL __MODW21U
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x16:
	LDI  R30,LOW(1)
	MOV  R4,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x17:
	MOV  R30,R5
	LDI  R31,0
	SBRC R30,7
	SER  R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x18:
	LDI  R26,LOW(0)
	RJMP _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 15 TIMES, CODE SIZE REDUCTION:40 WORDS
SUBOPT_0x19:
	LDS  R26,_mV
	LDS  R27,_mV+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1A:
	ST   -Y,R16
	RJMP SUBOPT_0x18

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1B:
	RCALL SUBOPT_0x19
	CPI  R26,LOW(0x10CD)
	LDI  R30,HIGH(0x10CD)
	CPC  R27,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x1C:
	LDI  R26,LOW(_securityMethod)
	LDI  R27,HIGH(_securityMethod)
	RCALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1D:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1E:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1F:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x20:
	MOV  R26,R17
	CLR  R27
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	RCALL __MODW21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x21:
	SUBI R30,-LOW(48)
	MOV  R26,R30
	RJMP _lcd_putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x22:
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x23:
	RCALL __DIVW21
	MOVW R26,R30
	RCALL SUBOPT_0xE
	RCALL __MODW21
	RJMP SUBOPT_0x21

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x24:
	LDI  R26,LOW(500)
	LDI  R27,HIGH(500)
	RJMP _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x25:
	LDI  R26,LOW(_fpsCount)
	LDI  R27,HIGH(_fpsCount)
	RCALL __EEPROMRDW
	MOVW R26,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x26:
	RCALL __DIVW21U
	MOVW R26,R30
	RJMP SUBOPT_0x15

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x27:
	SBIW R28,4
	LDI  R30,LOW(0)
	ST   Y,R30
	RJMP SUBOPT_0x13

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x28:
	LDI  R30,LOW(0)
	STD  Y+2,R30
	STD  Y+3,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x29:
	__GETD2S 4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x2A:
	RCALL __ADDD12
	__PUTD1S 4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:14 WORDS
SUBOPT_0x2B:
	__GETD1N 0xA
	RCALL __DIVD21
	__PUTD1S 4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x2C:
	__GETD1S 4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2D:
	RCALL __CWD1
	RCALL __ADDD21
	RJMP SUBOPT_0x2B

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2E:
	MOVW R26,R30
	MOVW R24,R22
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x2F:
	RCALL __SAVELOCR6
	__GETWRN 16,17,0
	__GETWRN 18,19,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x30:
	LDI  R30,LOW(0)
	STD  Y+7,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x31:
	LDD  R26,Y+7
	CPI  R26,LOW(0x5)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x32:
	LDD  R30,Y+7
	RCALL SUBOPT_0x11
	MOVW R26,R28
	ADIW R26,10
	LSL  R30
	ROL  R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x33:
	LDD  R30,Y+7
	SUBI R30,-LOW(1)
	STD  Y+7,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x34:
	ADD  R26,R30
	ADC  R27,R31
	RCALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x35:
	SUB  R30,R16
	SBC  R31,R17
	MOVW R26,R30
	RJMP _abs

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x36:
	RCALL SUBOPT_0x19
	CPI  R26,LOW(0x12C1)
	LDI  R30,HIGH(0x12C1)
	CPC  R27,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x37:
	RCALL SUBOPT_0x19
	CPI  R26,LOW(0x1005)
	LDI  R30,HIGH(0x1005)
	CPC  R27,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x38:
	STS  _elapsed_us,R30
	STS  _elapsed_us+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x39:
	STS  _elapsed_ms,R30
	STS  _elapsed_ms+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3A:
	LDS  R26,_elapsed_us
	LDS  R27,_elapsed_us+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x3B:
	CPI  R26,LOW(0x3E8)
	LDI  R30,HIGH(0x3E8)
	CPC  R27,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x3C:
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x3D:
	LDS  R26,_elapsed_ms
	LDS  R27,_elapsed_ms+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x3E:
	STS  _powerMode,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x3F:
	LDI  R26,LOW(100)
	LDI  R27,0
	RJMP _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x40:
	STS  _cpuHaltAllowed,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 15 TIMES, CODE SIZE REDUCTION:26 WORDS
SUBOPT_0x41:
	LDI  R27,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x42:
	__GETWRN 20,21,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x43:
	__ADDWRN 20,21,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x44:
	LDI  R26,LOW(_txPacket)
	LDI  R27,HIGH(_txPacket)
	ADD  R26,R20
	ADC  R27,R21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 36 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x45:
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x46:
	LDD  R30,Y+2
	RCALL SUBOPT_0x11
	RCALL __CWD1
	RCALL SUBOPT_0x2E
	RJMP _getCommand

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x47:
	__GETB2MN _rxPacket,10
	LDI  R30,LOW(48)
	RCALL __EQB12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x48:
	__GETD2N 0x0
	RJMP _getCommand

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x49:
	RCALL SUBOPT_0x45
	RJMP SUBOPT_0x48

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4A:
	RCALL __GETD1S0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x4B:
	RCALL __PUTD1S0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x4C:
	__GETB1MN _rxPacket,4
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x4D:
	__GETB2MN _rxPacket,10
	CPI  R26,LOW(0x31)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x4E:
	__POINTW2FN _0x80000,7
	RJMP SUBOPT_0x0

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x4F:
	RCALL _lcd_putsf
	RCALL _FPS_reset
	LDI  R30,LOW(0)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x50:
	RCALL _lcd_clear
	__POINTW2FN _0x80000,50
	RJMP SUBOPT_0x0

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x51:
	__POINTW2FN _0x80000,63
	RCALL _lcd_putsf
	RJMP _soundOK

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x52:
	RCALL _lcd_clear
	__POINTW2FN _0x80000,77
	RJMP SUBOPT_0x0

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x53:
	RCALL SUBOPT_0x41
	RJMP _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x54:
	RCALL SUBOPT_0x45
	LDI  R30,LOW(300)
	LDI  R31,HIGH(300)
	RCALL SUBOPT_0x45
	LDI  R26,LOW(200)
	RCALL SUBOPT_0x41
	RCALL _beepSwipe
	RJMP SUBOPT_0x3F

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x55:
	LDI  R30,LOW(3000)
	LDI  R31,HIGH(3000)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x56:
	RCALL SUBOPT_0x55
	RJMP SUBOPT_0x45

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x57:
	LDI  R30,LOW(400)
	LDI  R31,HIGH(400)
	RJMP SUBOPT_0x45

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x58:
	ST   -Y,R27
	ST   -Y,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x59:
	STD  Y+6,R30
	STD  Y+6+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5A:
	MOV  R30,R16
	LDI  R31,0
	SBRC R30,7
	SER  R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5B:
	SBI  0x18,4
	LD   R26,Y
	RCALL __lcd_write_data
	CBI  0x18,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x5C:
	LDI  R26,LOW(48)
	RCALL __lcd_write_nibble_G101
	__DELAY_USW 200
	RET


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x7D0
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

__ROUND_REPACK:
	TST  R21
	BRPL __REPACK
	CPI  R21,0x80
	BRNE __ROUND_REPACK0
	SBRS R30,0
	RJMP __REPACK
__ROUND_REPACK0:
	ADIW R30,1
	ADC  R22,R25
	ADC  R23,R25
	BRVS __REPACK1

__REPACK:
	LDI  R21,0x80
	EOR  R21,R23
	BRNE __REPACK0
	PUSH R21
	RJMP __ZERORES
__REPACK0:
	CPI  R21,0xFF
	BREQ __REPACK1
	LSL  R22
	LSL  R0
	ROR  R21
	ROR  R22
	MOV  R23,R21
	RET
__REPACK1:
	PUSH R21
	TST  R0
	BRMI __REPACK2
	RJMP __MAXRES
__REPACK2:
	RJMP __MINRES

__UNPACK:
	LDI  R21,0x80
	MOV  R1,R25
	AND  R1,R21
	LSL  R24
	ROL  R25
	EOR  R25,R21
	LSL  R21
	ROR  R24

__UNPACK1:
	LDI  R21,0x80
	MOV  R0,R23
	AND  R0,R21
	LSL  R22
	ROL  R23
	EOR  R23,R21
	LSL  R21
	ROR  R22
	RET

__CFD1U:
	SET
	RJMP __CFD1U0
__CFD1:
	CLT
__CFD1U0:
	PUSH R21
	RCALL __UNPACK1
	CPI  R23,0x80
	BRLO __CFD10
	CPI  R23,0xFF
	BRCC __CFD10
	RJMP __ZERORES
__CFD10:
	LDI  R21,22
	SUB  R21,R23
	BRPL __CFD11
	NEG  R21
	CPI  R21,8
	BRTC __CFD19
	CPI  R21,9
__CFD19:
	BRLO __CFD17
	SER  R30
	SER  R31
	SER  R22
	LDI  R23,0x7F
	BLD  R23,7
	RJMP __CFD15
__CFD17:
	CLR  R23
	TST  R21
	BREQ __CFD15
__CFD18:
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
	DEC  R21
	BRNE __CFD18
	RJMP __CFD15
__CFD11:
	CLR  R23
__CFD12:
	CPI  R21,8
	BRLO __CFD13
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R23
	SUBI R21,8
	RJMP __CFD12
__CFD13:
	TST  R21
	BREQ __CFD15
__CFD14:
	LSR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	DEC  R21
	BRNE __CFD14
__CFD15:
	TST  R0
	BRPL __CFD16
	RCALL __ANEGD1
__CFD16:
	POP  R21
	RET

__CDF1U:
	SET
	RJMP __CDF1U0
__CDF1:
	CLT
__CDF1U0:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __CDF10
	CLR  R0
	BRTS __CDF11
	TST  R23
	BRPL __CDF11
	COM  R0
	RCALL __ANEGD1
__CDF11:
	MOV  R1,R23
	LDI  R23,30
	TST  R1
__CDF12:
	BRMI __CDF13
	DEC  R23
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R1
	RJMP __CDF12
__CDF13:
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R1
	PUSH R21
	RCALL __REPACK
	POP  R21
__CDF10:
	RET

__SWAPACC:
	PUSH R20
	MOVW R20,R30
	MOVW R30,R26
	MOVW R26,R20
	MOVW R20,R22
	MOVW R22,R24
	MOVW R24,R20
	MOV  R20,R0
	MOV  R0,R1
	MOV  R1,R20
	POP  R20
	RET

__UADD12:
	ADD  R30,R26
	ADC  R31,R27
	ADC  R22,R24
	RET

__NEGMAN1:
	COM  R30
	COM  R31
	COM  R22
	SUBI R30,-1
	SBCI R31,-1
	SBCI R22,-1
	RET

__SUBF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R25,0x80
	BREQ __ADDF129
	LDI  R21,0x80
	EOR  R1,R21

__ADDF120:
	CPI  R23,0x80
	BREQ __ADDF128
__ADDF121:
	MOV  R21,R23
	SUB  R21,R25
	BRVS __ADDF1211
	BRPL __ADDF122
	RCALL __SWAPACC
	RJMP __ADDF121
__ADDF122:
	CPI  R21,24
	BRLO __ADDF123
	CLR  R26
	CLR  R27
	CLR  R24
__ADDF123:
	CPI  R21,8
	BRLO __ADDF124
	MOV  R26,R27
	MOV  R27,R24
	CLR  R24
	SUBI R21,8
	RJMP __ADDF123
__ADDF124:
	TST  R21
	BREQ __ADDF126
__ADDF125:
	LSR  R24
	ROR  R27
	ROR  R26
	DEC  R21
	BRNE __ADDF125
__ADDF126:
	MOV  R21,R0
	EOR  R21,R1
	BRMI __ADDF127
	RCALL __UADD12
	BRCC __ADDF129
	ROR  R22
	ROR  R31
	ROR  R30
	INC  R23
	BRVC __ADDF129
	RJMP __MAXRES
__ADDF128:
	RCALL __SWAPACC
__ADDF129:
	RCALL __REPACK
	POP  R21
	RET
__ADDF1211:
	BRCC __ADDF128
	RJMP __ADDF129
__ADDF127:
	SUB  R30,R26
	SBC  R31,R27
	SBC  R22,R24
	BREQ __ZERORES
	BRCC __ADDF1210
	COM  R0
	RCALL __NEGMAN1
__ADDF1210:
	TST  R22
	BRMI __ADDF129
	LSL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVC __ADDF1210

__ZERORES:
	CLR  R30
	CLR  R31
	CLR  R22
	CLR  R23
	POP  R21
	RET

__MINRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	SER  R23
	POP  R21
	RET

__MAXRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	LDI  R23,0x7F
	POP  R21
	RET

__MULF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BREQ __ZERORES
	CPI  R25,0x80
	BREQ __ZERORES
	EOR  R0,R1
	SEC
	ADC  R23,R25
	BRVC __MULF124
	BRLT __ZERORES
__MULF125:
	TST  R0
	BRMI __MINRES
	RJMP __MAXRES
__MULF124:
	PUSH R0
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R17
	CLR  R18
	CLR  R25
	MUL  R22,R24
	MOVW R20,R0
	MUL  R24,R31
	MOV  R19,R0
	ADD  R20,R1
	ADC  R21,R25
	MUL  R22,R27
	ADD  R19,R0
	ADC  R20,R1
	ADC  R21,R25
	MUL  R24,R30
	RCALL __MULF126
	MUL  R27,R31
	RCALL __MULF126
	MUL  R22,R26
	RCALL __MULF126
	MUL  R27,R30
	RCALL __MULF127
	MUL  R26,R31
	RCALL __MULF127
	MUL  R26,R30
	ADD  R17,R1
	ADC  R18,R25
	ADC  R19,R25
	ADC  R20,R25
	ADC  R21,R25
	MOV  R30,R19
	MOV  R31,R20
	MOV  R22,R21
	MOV  R21,R18
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	POP  R0
	TST  R22
	BRMI __MULF122
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	RJMP __MULF123
__MULF122:
	INC  R23
	BRVS __MULF125
__MULF123:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__MULF127:
	ADD  R17,R0
	ADC  R18,R1
	ADC  R19,R25
	RJMP __MULF128
__MULF126:
	ADD  R18,R0
	ADC  R19,R1
__MULF128:
	ADC  R20,R25
	ADC  R21,R25
	RET

__DIVF21:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BRNE __DIVF210
	TST  R1
__DIVF211:
	BRPL __DIVF219
	RJMP __MINRES
__DIVF219:
	RJMP __MAXRES
__DIVF210:
	CPI  R25,0x80
	BRNE __DIVF218
__DIVF217:
	RJMP __ZERORES
__DIVF218:
	EOR  R0,R1
	SEC
	SBC  R25,R23
	BRVC __DIVF216
	BRLT __DIVF217
	TST  R0
	RJMP __DIVF211
__DIVF216:
	MOV  R23,R25
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R1
	CLR  R17
	CLR  R18
	CLR  R19
	CLR  R20
	CLR  R21
	LDI  R25,32
__DIVF212:
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	CPC  R20,R17
	BRLO __DIVF213
	SUB  R26,R30
	SBC  R27,R31
	SBC  R24,R22
	SBC  R20,R17
	SEC
	RJMP __DIVF214
__DIVF213:
	CLC
__DIVF214:
	ROL  R21
	ROL  R18
	ROL  R19
	ROL  R1
	ROL  R26
	ROL  R27
	ROL  R24
	ROL  R20
	DEC  R25
	BRNE __DIVF212
	MOVW R30,R18
	MOV  R22,R1
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	TST  R22
	BRMI __DIVF215
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVS __DIVF217
__DIVF215:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__ADDD12:
	ADD  R30,R26
	ADC  R31,R27
	ADC  R22,R24
	ADC  R23,R25
	RET

__ADDD21:
	ADD  R26,R30
	ADC  R27,R31
	ADC  R24,R22
	ADC  R25,R23
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__ANEGD1:
	COM  R31
	COM  R22
	COM  R23
	NEG  R30
	SBCI R31,-1
	SBCI R22,-1
	SBCI R23,-1
	RET

__LSLD12:
	TST  R30
	MOV  R0,R30
	MOVW R30,R26
	MOVW R22,R24
	BREQ __LSLD12R
__LSLD12L:
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
	DEC  R0
	BRNE __LSLD12L
__LSLD12R:
	RET

__LSLW3:
	LSL  R30
	ROL  R31
__LSLW2:
	LSL  R30
	ROL  R31
	LSL  R30
	ROL  R31
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	RET

__CWD2:
	MOV  R24,R27
	ADD  R24,R24
	SBC  R24,R24
	MOV  R25,R24
	RET

__EQB12:
	CP   R30,R26
	LDI  R30,1
	BREQ __EQB12T
	CLR  R30
__EQB12T:
	RET

__MULW12U:
	MUL  R31,R26
	MOV  R31,R0
	MUL  R30,R27
	ADD  R31,R0
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	RET

__MULD12U:
	MUL  R23,R26
	MOV  R23,R0
	MUL  R22,R27
	ADD  R23,R0
	MUL  R31,R24
	ADD  R23,R0
	MUL  R30,R25
	ADD  R23,R0
	MUL  R22,R26
	MOV  R22,R0
	ADD  R23,R1
	MUL  R31,R27
	ADD  R22,R0
	ADC  R23,R1
	MUL  R30,R24
	ADD  R22,R0
	ADC  R23,R1
	CLR  R24
	MUL  R31,R26
	MOV  R31,R0
	ADD  R22,R1
	ADC  R23,R24
	MUL  R30,R27
	ADD  R31,R0
	ADC  R22,R1
	ADC  R23,R24
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	ADC  R22,R24
	ADC  R23,R24
	RET

__MULW12:
	RCALL __CHKSIGNW
	RCALL __MULW12U
	BRTC __MULW121
	RCALL __ANEGW1
__MULW121:
	RET

__MULD12:
	RCALL __CHKSIGND
	RCALL __MULD12U
	BRTC __MULD121
	RCALL __ANEGD1
__MULD121:
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__DIVW21:
	RCALL __CHKSIGNW
	RCALL __DIVW21U
	BRTC __DIVW211
	RCALL __ANEGW1
__DIVW211:
	RET

__DIVD21U:
	PUSH R19
	PUSH R20
	PUSH R21
	CLR  R0
	CLR  R1
	CLR  R20
	CLR  R21
	LDI  R19,32
__DIVD21U1:
	LSL  R26
	ROL  R27
	ROL  R24
	ROL  R25
	ROL  R0
	ROL  R1
	ROL  R20
	ROL  R21
	SUB  R0,R30
	SBC  R1,R31
	SBC  R20,R22
	SBC  R21,R23
	BRCC __DIVD21U2
	ADD  R0,R30
	ADC  R1,R31
	ADC  R20,R22
	ADC  R21,R23
	RJMP __DIVD21U3
__DIVD21U2:
	SBR  R26,1
__DIVD21U3:
	DEC  R19
	BRNE __DIVD21U1
	MOVW R30,R26
	MOVW R22,R24
	MOVW R26,R0
	MOVW R24,R20
	POP  R21
	POP  R20
	POP  R19
	RET

__DIVD21:
	RCALL __CHKSIGND
	RCALL __DIVD21U
	BRTC __DIVD211
	RCALL __ANEGD1
__DIVD211:
	RET

__MODW21U:
	RCALL __DIVW21U
	MOVW R30,R26
	RET

__MODW21:
	CLT
	SBRS R27,7
	RJMP __MODW211
	COM  R26
	COM  R27
	ADIW R26,1
	SET
__MODW211:
	SBRC R31,7
	RCALL __ANEGW1
	RCALL __DIVW21U
	MOVW R30,R26
	BRTC __MODW212
	RCALL __ANEGW1
__MODW212:
	RET

__CHKSIGNW:
	CLT
	SBRS R31,7
	RJMP __CHKSW1
	RCALL __ANEGW1
	SET
__CHKSW1:
	SBRS R27,7
	RJMP __CHKSW2
	COM  R26
	COM  R27
	ADIW R26,1
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSW2:
	RET

__CHKSIGND:
	CLT
	SBRS R23,7
	RJMP __CHKSD1
	RCALL __ANEGD1
	SET
__CHKSD1:
	SBRS R25,7
	RJMP __CHKSD2
	CLR  R0
	COM  R26
	COM  R27
	COM  R24
	COM  R25
	ADIW R26,1
	ADC  R24,R0
	ADC  R25,R0
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSD2:
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__GETD1S0:
	LD   R30,Y
	LDD  R31,Y+1
	LDD  R22,Y+2
	LDD  R23,Y+3
	RET

__GETD2S0:
	LD   R26,Y
	LDD  R27,Y+1
	LDD  R24,Y+2
	LDD  R25,Y+3
	RET

__PUTD1S0:
	ST   Y,R30
	STD  Y+1,R31
	STD  Y+2,R22
	STD  Y+3,R23
	RET

__CLRD1S0:
	ST   Y,R30
	STD  Y+1,R30
	STD  Y+2,R30
	STD  Y+3,R30
	RET

__PUTPARD2:
	ST   -Y,R25
	ST   -Y,R24
	ST   -Y,R27
	ST   -Y,R26
	RET

__SWAPD12:
	MOV  R1,R24
	MOV  R24,R22
	MOV  R22,R1
	MOV  R1,R25
	MOV  R25,R23
	MOV  R23,R1

__SWAPW12:
	MOV  R1,R27
	MOV  R27,R31
	MOV  R31,R1

__SWAPB12:
	MOV  R1,R26
	MOV  R26,R30
	MOV  R30,R1
	RET

__EEPROMRDW:
	ADIW R26,1
	RCALL __EEPROMRDB
	MOV  R31,R30
	SBIW R26,1

__EEPROMRDB:
	SBIC EECR,EEWE
	RJMP __EEPROMRDB
	PUSH R31
	IN   R31,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R30,EEDR
	OUT  SREG,R31
	POP  R31
	RET

__EEPROMWRW:
	RCALL __EEPROMWRB
	ADIW R26,1
	PUSH R30
	MOV  R30,R31
	RCALL __EEPROMWRB
	POP  R30
	SBIW R26,1
	RET

__EEPROMWRB:
	SBIS EECR,EEWE
	RJMP __EEPROMWRB1
	WDR
	RJMP __EEPROMWRB
__EEPROMWRB1:
	IN   R25,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R24,EEDR
	CP   R30,R24
	BREQ __EEPROMWRB0
	OUT  EEDR,R30
	SBI  EECR,EEMWE
	SBI  EECR,EEWE
__EEPROMWRB0:
	OUT  SREG,R25
	RET

__CPW02:
	CLR  R0
	CP   R0,R26
	CPC  R0,R27
	RET

__CPD12:
	CP   R30,R26
	CPC  R31,R27
	CPC  R22,R24
	CPC  R23,R25
	RET

__CPD21:
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	CPC  R25,R23
	RET

__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

__LOADLOCR2P:
	LD   R16,Y+
	LD   R17,Y+
	RET

;END OF CODE MARKER
__END_OF_CODE:
