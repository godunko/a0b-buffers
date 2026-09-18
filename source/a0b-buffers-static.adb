--
--  Copyright (C) 2026, Vadim Godunko
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
--

package body A0B.Buffers.Static with Pure is

   -----------------------
   -- Set_Actual_Length --
   -----------------------

   overriding procedure Set_Actual_Length
     (Self : in out Static_Buffer; To : Storage_Count) is
   begin
      Self.Actual_Length := To;
   end Set_Actual_Length;

   ---------------------------
   -- Set_Allocation_Length --
   ---------------------------

   overriding procedure Set_Allocation_Length
     (Self : in out Static_Buffer; To : Storage_Count) is
   begin
      Self.Allocation_Length := To;
   end Set_Allocation_Length;

end A0B.Buffers.Static;
