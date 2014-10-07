#ifndef COMS_DEFINED
#define COMS_DEFINED

#define NotSet	0x00	// Default value for enum. Scanner will return error if sent this.
#define FPSOpen	0x01	// Open Initialization
#define FPSClose	0x02	// Close Termination
#define UsbInternalCheck	0x03	// UsbInternalCheck Check if the connected USB device is valid
#define ChangeEBaudRate	0x04	// ChangeBaudrate Change UART baud rate
#define SetIAPMode	0x05	// SetIAPMode Enter IAP Mode In this mode FW Upgrade is available
#define CmosLed	0x12	// CmosLed Control CMOS LED
#define GetEnrollCount	0x20	// Get enrolled fingerprint count
#define CheckEnrolled	0x21	// Check whether the specified ID is already enrolled
#define EnrollStart	0x22	// Start an enrollment
#define Enroll1	0x23	// Make 1st template for an enrollment
#define Enroll2	0x24	// Make 2nd template for an enrollment
#define Enroll3	0x25	// Make 3rd template for an enrollment merge three templates into one template save merged template to the database
#define IsPressFinger	0x26	// Check if a finger is placed on the sensor
#define DeleteID	0x40	// Delete the fingerprint with the specified ID
#define DeleteAll	0x41	// Delete all fingerprints from the database
#define Verify1_1	0x50	// Verification of the capture fingerprint image with the specified ID
#define Identify1_N	0x51	// Identification of the capture fingerprint image with the database
#define VerifyTemplate1_1	0x52	// Verification of a fingerprint template with the specified ID
#define IdentifyTemplate1_N	0x53	// Identification of a fingerprint template with the database
#define CaptureFinger	0x60	// Capture a fingerprint image(256x256) from the sensor
#define MakeTemplate	0x61	// Make template for transmission
#define GetImage	0x62	// Download the captured fingerprint image(256x256)
#define GetRawImage	0x63	// Capture & Download raw fingerprint image(320x240)
#define GetTemplate	0x70	// Download the template of the specified ID
#define SetTemplate	0x71	// Upload the template of the specified ID
#define GetDatabaseStart	0x72	// Start database download obsolete
#define GetDatabaseEnd	0x73	// End database download obsolete
#define UpgradeFirmware	0x80	// Not supported
#define UpgradeISOCDImage	0x81	// Not supported
#define Ack	0x30	// Acknowledge.
#define Nack	0x31	// Non-acknowledge

#define COMMAND_START_CODE_1 0x55	// Static byte to mark the beginning of a command packet - never changes
#define COMMAND_START_CODE_2 0xAA	// Static byte to mark the beginning of a command packet - never changes
#define COMMAND_DEVICE_ID_1 0x01	// Device ID Byte 1 (lesser byte) - theoretically never changes
#define COMMAND_DEVICE_ID_2 0x00	// Device ID Byte 2 (greater byte)


#endif
