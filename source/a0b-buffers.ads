--
--  Copyright (C) 2026, Vadim Godunko
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
--

--  Abstract buffer definitions. Children packages implements specific buffer
--  types.

with System.Storage_Elements;

package A0B.Buffers with Pure is

   type Storage_Offset is
     range -System.Memory_Size / 2 .. System.Memory_Size / 2 - 1;
   subtype Storage_Count is Storage_Offset range 0 .. Storage_Offset'Last;

   type Abstract_Buffer is abstract tagged limited private;

   not overriding function Capacity
     (Self : Abstract_Buffer) return Storage_Count is abstract;
   --  Returns the maximum number of storage elements the buffer can hold.

   not overriding function Address
     (Self : Abstract_Buffer) return System.Address is abstract;
   --  Returns the memory address of the buffer's storage.

   not overriding function Length
     (Self : Abstract_Buffer) return Storage_Count is abstract;
   --  Returns the current number of storage elements in the buffer to be
   --  processed. Note, returned value is limited by the allocation length if
   --  defined.

   not overriding procedure Set_Allocation_Length
     (Self : in out Abstract_Buffer;
      To   : Storage_Count) is abstract;
   --  Sets the buffer's allocation length to the specified value.

   not overriding procedure Set_Actual_Length
     (Self : in out Abstract_Buffer;
      To   : Storage_Count) is abstract;
   --  Sets the buffer's length to the specified value.

private

   type Abstract_Buffer is abstract tagged limited record
      Allocation_Length : Storage_Count := 0;
      Actual_Length     : Storage_Count := 0;
   end record;

end A0B.Buffers;
