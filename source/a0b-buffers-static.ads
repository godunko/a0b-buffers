--
--  Copyright (C) 2026, Vadim Godunko
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
--

private with A0B.Types;

package A0B.Buffers.Static with Pure is

   type Static_Buffer (Capacity : Storage_Count) is
     new A0B.Buffers.Abstract_Buffer with private;

private

   type Storage_Unit is new A0B.Types.Unsigned_8;

   subtype Storage_Index is Storage_Count range 1 .. Storage_Count'Last;

   type Storage_Unit_Array is
     array (Storage_Index range <>) of Storage_Unit;

   type Static_Buffer (Capacity : Storage_Count) is
     new Abstract_Buffer with record
      Storage : Storage_Unit_Array (1 .. Capacity);
   end record;

   overriding function Address (Self : Static_Buffer) return System.Address is
     (Self.Storage'Address);

   overriding function Capacity (Self : Static_Buffer) return Storage_Count is
     (Self.Capacity);

   overriding function Length (Self : Static_Buffer) return Storage_Count is
     ((if Self.Allocation_Length = 0
         then Self.Actual_Length
         else Storage_Count'Min
                (Self.Allocation_Length, Self.Actual_Length)));

   overriding procedure Set_Allocation_Length
     (Self : in out Static_Buffer; To : Storage_Count);

   overriding procedure Set_Actual_Length
     (Self : in out Static_Buffer; To : Storage_Count);

end A0B.Buffers.Static;
