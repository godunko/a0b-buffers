--
--  Copyright (C) 2026, Vadim Godunko
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
--

--  Abstract buffer definitions. Children packages implements specific buffer
--  types.

with System.Storage_Elements;

package A0B.Buffers with Pure is

   type Abstract_Buffer is abstract tagged limited private;

   not overriding function Capacity
     (Self : Abstract_Buffer) return System.Storage_Elements.Storage_Count
        is abstract;
   --  Returns the maximum number of storage elements the buffer can hold.

   not overriding function Address
     (Self : Abstract_Buffer) return System.Address is abstract;
   --  Returns the memory address of the buffer's storage.

   not overriding function Length
     (Self : Abstract_Buffer) return System.Storage_Elements.Storage_Count
        is abstract;
   --  Returns the current number of storage elements in the buffer to be
   --  processed. Note, returned value is limited by the allocation length if
   --  defined.

   not overriding function Expected_Length
     (Self : Abstract_Buffer) return System.Storage_Elements.Storage_Count;
   --  Returns maximum size of data expected to be stored into buffer. It is
   --  minimum of buffer's capacity and allocation length.

   not overriding function Allocation_Length
     (Self : Abstract_Buffer) return System.Storage_Elements.Storage_Count;
   --  Returns buffer's allocation length, if was set, or
   --  `Storage_Count'Last`.

   not overriding procedure Set_Allocation_Length
     (Self : in out Abstract_Buffer;
      To   : System.Storage_Elements.Storage_Count) is abstract;
   --  Sets the buffer's allocation length to the specified value.

   not overriding procedure Set_Actual_Length
     (Self : in out Abstract_Buffer;
      To   : System.Storage_Elements.Storage_Count) is abstract;
   --  Sets the buffer's length to the specified value.

private

   type Abstract_Buffer is abstract tagged limited record
      Allocation_Length : System.Storage_Elements.Storage_Count :=
        System.Storage_Elements.Storage_Count'Last;
      Actual_Length     : System.Storage_Elements.Storage_Count := 0;
   end record;

   not overriding function Allocation_Length
     (Self : Abstract_Buffer) return System.Storage_Elements.Storage_Count is
       (Self.Allocation_Length);

   not overriding function Expected_Length
     (Self : Abstract_Buffer) return System.Storage_Elements.Storage_Count is
        (System.Storage_Elements.Storage_Count'Min
           (Abstract_Buffer'Class (Self).Capacity, Self.Allocation_Length));

end A0B.Buffers;
