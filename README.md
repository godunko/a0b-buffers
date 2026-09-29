# A0B: Data Buffers

The **Data Buffer** abstraction provides a unified mechanism for zero-copy data transfer between applications and input/output (I/O) subsystems.

## Core Properties

A data buffer tracks four primary attributes:

* **Storage Address:** Address of the buffer's backing storage.
* **Storage Capacity:** Maximum number of storage elements the buffer can hold.
* **Actual Data Length:** Length of valid data currently in the buffer.
* **Allocation Length:** Upper limit on the data length, typically set by the data consumer.

`Length` returns the effective data length: the actual data length, capped by the allocation length when one is set.

---

## Usage Examples

### Mapping a Data Buffer to User-Defined Record Types

Data buffers can be mapped directly to structured Ada record types, once the length is checked, without copying data, enabling zero-copy decoding of binary wire protocols or command descriptor blocks (CDBs).

For example, decoding a SCSI `READ(10)` command:

```ada
   READ_10_CDB_Length : constant := 10;
   Byte_Size          : constant := 8;

   type READ_10_CDB is record
      OPERATION_CODE        : A0B.SCSI.SAM5.OPERATION_CODE :=
        A0B.SCSI.SBC4.READ_10;
      RDPROTECT             : A0B.Types.Unsigned_3;
      DPO                   : Boolean;
      FUA                   : Boolean;
      RARC                  : Boolean;
      LOGICAL_BLOCK_ADDRESS : A0B.Types.Big_Endian.Unsigned_32;
      GROUP_NUMBER          : A0B.Types.Unsigned_6;
      TRANSFER_LENGTH       : A0B.Types.Big_Endian.Unsigned_16;
      CONTROL               : A0B.SCSI.SAM5.CONTROL;
   end record
     with Size      => READ_10_CDB_Length * Byte_Size,
          Bit_Order => System.Low_Order_First;
```

The buffer can then be mapped without copying:

```ada
   if Buffer.Length /= READ_10_CDB_Length then
      --  The buffer length must be checked explicitly
      return Error;
   end if;

   declare
      CDB : constant READ_10_CDB
        with Import, Address => Buffer.Address;
   begin
      --  Process CDB directly from the buffer address
      return Success;
   end;
```

### Mapping to a Byte Array

You can overlay an array of bytes onto the buffer's storage. This preserves Ada bounds checking while avoiding data copies.

```ada
   declare
      --  Array bounds match Buffer.Length (the actual length, capped by the
      --  allocation length)
      Data : constant A0B.Types.Arrays.Unsigned_8_Array
        (1 .. A0B.Types.Unsigned_32 (Buffer.Length))
          with Import, Address => Buffer.Address;

      X : A0B.Types.Unsigned_8;
   begin
      --  Accessing beyond Buffer.Length triggers standard runtime checks:
      X := Data (Data'Last + 1);  --  Raises Constraint_Error
   end;
```
