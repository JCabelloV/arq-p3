module test;
    reg           clk = 0;
    wire [7:0]    regA_out;
    wire [7:0]    regB_out;
    wire [7:0] alu_out;
    wire [14:0] im_out;

    reg mem_sequence_test_failed = 1'b0;
    reg add_a_dir_test_failed = 1'b0;
    reg sub_dir_test_failed = 1'b0;
    reg and_a_b_ind_test_failed = 1'b0;
    reg or_b_dir_test_failed = 1'b0;
    reg not_b_ind_test_failed = 1'b0;
    reg xor_a_dir_test_failed = 1'b0;
    reg shl_dir_b_test_failed = 1'b0;
    reg shr_b_ind_test_failed = 1'b0;
    reg inc_dir_test_failed = 1'b0;
    reg rst_b_ind_test_failed = 1'b0;
    reg jle_equal_test_failed = 1'b0;
    reg for_loop_test_failed = 1'b0;

    // ------------------------------------------------------------
    // IMPORTANTE!! Editar con el modulo de su computador
    // ------------------------------------------------------------
    computer Comp (
    .clk(clk)                      // Connects to the main clock signal
);
    // ------------------------------------------------------------

    // ------------------------------------------------------------
    // IMPORTANTE!! Editar para que la variable apunte a la salida
    // de los registros de su computador.
    // ------------------------------------------------------------
    assign regA_out = Comp.regA.out;
    assign regB_out = Comp.regB.out;
    // ------------------------------------------------------------

    initial begin
        $dumpfile("out/dump.vcd");
        $dumpvars(0, test);
        $readmemb("im_memory.dat", Comp.IM.mem);

        // --- Test: Full & Expanded Memory Sequence ---
        $display("\n----- STARTING TEST: Full Memory Sequence -----");

        // --- Part 1: Original Test (RegB -> Mem -> RegA) ---
        $display("\n--- Part 1: Testing RegB -> Memory -> RegA ---");

        // Check Inst 0: MOV B, 99 | Purpose: Verify that register B is loaded with the immediate value 99.
        #2;
        $display("CHECK @ t=%0t: After MOV B, 99 -> regB = %d", $time, regB_out);
        if (regB_out !== 8'd99) begin
            $error("FAIL [Part 1]: regB expected 99, got %d", regB_out);
            mem_sequence_test_failed = 1'b1;
        end

        // Check Inst 1: MOV (50), B | Purpose: Verify that the value from register B (99) is stored in DM[50].
        #2;
        $display("CHECK @ t=%0t: After MOV (50), B -> DM[50] = %d", $time, Comp.DM.mem[50]);
        if (Comp.DM.mem[50] !== 8'd99) begin
            $error("FAIL [Part 1]: DM[50] expected 99, got %d", Comp.DM.mem[50]);
            mem_sequence_test_failed = 1'b1;
        end

        // Check Inst 2: MOV A, (50) | Purpose: Verify that register A is loaded with the value from DM[50] (99).
        #2;
        $display("CHECK @ t=%0t: After MOV A, (50) -> regA = %d", $time, regA_out);
        if (regA_out !== 8'd99) begin
            $error("FAIL [Part 1]: regA expected 99, got %d", regA_out);
            mem_sequence_test_failed = 1'b1;
        end

        // --- Part 2: Symmetric Test (RegA -> Mem -> RegB) ---
        $display("\n--- Part 2: Testing RegA -> Memory -> RegB ---");

        // Check Inst 3: MOV A, 123 | Purpose: Verify that register A is loaded with the immediate value 123.
        #2;
        $display("CHECK @ t=%0t: After MOV A, 123 -> regA = %d", $time, regA_out);
        if (regA_out !== 8'd123) begin
            $error("FAIL [Part 2]: regA expected 123, got %d", regA_out);
            mem_sequence_test_failed = 1'b1;
        end

        // Check Inst 4: MOV (51), A | Purpose: Verify that the value from register A (123) is stored in DM[51].
        #2;
        $display("CHECK @ t=%0t: After MOV (51), A -> DM[51] = %d", $time, Comp.DM.mem[51]);
        if (Comp.DM.mem[51] !== 8'd123) begin
            $error("FAIL [Part 2]: DM[51] expected 123, got %d", Comp.DM.mem[51]);
            mem_sequence_test_failed = 1'b1;
        end

        // Check Inst 5: MOV B, (51) | Purpose: Verify that register B is loaded with the value from DM[51] (123).
        #2;
        $display("CHECK @ t=%0t: After MOV B, (51) -> regB = %d", $time, regB_out);
        if (regB_out !== 8'd123) begin
            $error("FAIL [Part 2]: regB expected 123, got %d", regB_out);
            mem_sequence_test_failed = 1'b1;
        end

        // --- Part 3: Overwrite and Edge Case Test (0 and 255) ---
        $display("\n--- Part 3: Testing Overwrite and Edge Cases ---");

        // Check Inst 6: MOV A, 255 | Purpose: Verify that register A is loaded with the immediate value 255.
        #2;
        $display("CHECK @ t=%0t: After MOV A, 255 -> regA = %d", $time, regA_out);
        if (regA_out !== 8'd255) begin
            $error("FAIL [Part 3]: regA expected 255, got %d", regA_out);
            mem_sequence_test_failed = 1'b1;
        end

        // Check Inst 7: MOV (50), A | Purpose: Verify that the value from register A (255) overwrites the content of DM[50].
        #2;
        $display("CHECK @ t=%0t: After MOV (50), A [Overwrite] -> DM[50] = %d", $time, Comp.DM.mem[50]);
        if (Comp.DM.mem[50] !== 8'd255) begin
            $error("FAIL [Part 3]: DM[50] expected 255 after overwrite, got %d", Comp.DM.mem[50]);
            mem_sequence_test_failed = 1'b1;
        end

        // Check Inst 8: MOV A, 0 | Purpose: Verify that register A is loaded with the immediate value 0.
        #2;
        $display("CHECK @ t=%0t: After MOV A, 0 -> regA = %d", $time, regA_out);
        if (regA_out !== 8'd0) begin
            $error("FAIL [Part 3]: regA expected 0, got %d", regA_out);
            mem_sequence_test_failed = 1'b1;
        end

        // Check Inst 9: MOV A, (50) | Purpose: Verify that register A reads the overwritten value (255) from DM[50].
        #2;
        $display("CHECK @ t=%0t: After MOV A, (50) [Read Overwritten Value] -> regA = %d", $time, regA_out);
        if (regA_out !== 8'd255) begin
            $error("FAIL [Part 3]: Read of overwritten DM[50] expected 255, got %d", regA_out);
            mem_sequence_test_failed = 1'b1;
        end

        // --- Final Summary for this Test Block ---
        if (!mem_sequence_test_failed) begin
            $display(">>>>> ALL MEMORY SEQUENCE TESTS PASSED! <<<<< ");
        end else begin
            $display(">>>>> MEMORY SEQUENCE TEST FAILED! <<<<< ");
        end

        // --- Test: ADD A, (Dir) ---
        $display("\n----- STARTING TEST: ADD A, (Dir) -----");

        // Check Inst 10: MOV A, 100 | Purpose: Verify that register A is loaded with the operand 100.
        #2;
        $display("CHECK @ t=%0t: After MOV A, 100 -> regA = %d", $time, regA_out);
        if (regA_out !== 8'd100) begin
            $error("FAIL [ADD A, Dir]: regA expected 100, got %d", regA_out);
            add_a_dir_test_failed = 1'b1;
        end

        // Check Inst 11: MOV B, 50 | Purpose: Verify that register B is loaded with the operand 50.
        #2;
        $display("CHECK @ t=%0t: After MOV B, 50 -> regB = %d", $time, regB_out);
        if (regB_out !== 8'd50) begin
            $error("FAIL [ADD A, Dir]: regB expected 50, got %d", regB_out);
            add_a_dir_test_failed = 1'b1;
        end

        // Check Inst 12: MOV (120), B | Purpose: Verify that the value from register B (50) is stored in DM[120].
        #2;
        $display("CHECK @ t=%0t: After MOV (120), B -> DM[120] = %d", $time, Comp.DM.mem[120]);
        if (Comp.DM.mem[120] !== 8'd50) begin
            $error("FAIL [ADD A, Dir]: DM[120] expected 50, got %d", Comp.DM.mem[120]);
            add_a_dir_test_failed = 1'b1;
        end

        // Check Inst 13: ADD A, (120) | Purpose: Verify that regA = regA + DM[120] (100 + 50 = 150).
        #2;
        $display("CHECK @ t=%0t: After ADD A, (120) -> regA = %d", $time, regA_out);
        if (regA_out !== 8'd150) begin
            $error("FAIL [ADD A, Dir]: regA expected 150, got %d", regA_out);
            add_a_dir_test_failed = 1'b1;
        end

        // --- Final Summary for this Test Block ---
        if (!add_a_dir_test_failed) begin
            $display(">>>>> ADD A, (Dir) TEST PASSED! <<<<< ");
        end else begin
            $display(">>>>> ADD A, (Dir) TEST FAILED! <<<<< ");
        end

        // --- Test: SUB (Dir) ---
        $display("\n----- STARTING TEST: SUB (Dir) -----");

        // --- Step 1: MOV A, 100 (Setup minuend) ---
        #2;
        $display("CHECK @ t=%0t: After MOV A, 100 -> regA = %d", $time, regA_out);
        if (regA_out !== 8'd100) begin
            $error("FAIL [SUB (Dir)]: regA expected 100, got %d", regA_out);
            sub_dir_test_failed = 1'b1;
        end

        // --- Step 2: MOV B, 40 (Setup subtrahend) ---
        #2;
        $display("CHECK @ t=%0t: After MOV B, 40 -> regB = %d", $time, regB_out);
        if (regB_out !== 8'd40) begin
            $error("FAIL [SUB (Dir)]: regB expected 40, got %d", regB_out);
            sub_dir_test_failed = 1'b1;
        end

        // --- Step 3: SUB (200) (Execute subtraction and store) ---
        #2;
        // Expected result in memory: 100 - 40 = 60
        $display("CHECK @ t=%0t: After SUB (200) -> DM[200] = %d", $time, Comp.DM.mem[200]);
        if (Comp.DM.mem[200] !== 8'd60) begin
            $error("FAIL [SUB (Dir)]: DM[200] expected 60, got %d", Comp.DM.mem[200]);
            sub_dir_test_failed = 1'b1;
        end

        // --- Final Summary for this Test Block ---
        if (!sub_dir_test_failed) begin
            $display(">>>>> SUB (Dir) TEST PASSED! <<<<< ");
        end else begin
            $display(">>>>> SUB (Dir) TEST FAILED! <<<<< ");
        end

        // --- Test: AND A, (B) ---
        $display("\n----- STARTING TEST: AND A, (B) [Indirect Addressing] -----");

        // --- Step 1: MOV A, 170 (Prepare value for memory) ---
        #2;
        $display("CHECK @ t=%0t: After MOV A, 170 -> regA = %d", $time, regA_out);
        if (regA_out !== 8'd170) begin
            $error("FAIL [AND A, (B)]: regA expected 170, got %d", regA_out);
            and_a_b_ind_test_failed = 1'b1;
        end

        // --- Step 2: MOV (150), A (Store value in memory) ---
        #2;
        $display("CHECK @ t=%0t: After MOV (150), A -> DM[150] = %d", $time, Comp.DM.mem[150]);
        if (Comp.DM.mem[150] !== 8'd170) begin
            $error("FAIL [AND A, (B)]: DM[150] expected 170, got %d", Comp.DM.mem[150]);
            and_a_b_ind_test_failed = 1'b1;
        end

        // --- Step 3: MOV A, 204 (Setup first operand) ---
        #2;
        $display("CHECK @ t=%0t: After MOV A, 204 -> regA = %d", $time, regA_out);
        if (regA_out !== 8'd204) begin
            $error("FAIL [AND A, (B)]: regA expected 204, got %d", regA_out);
            and_a_b_ind_test_failed = 1'b1;
        end

        // --- Step 4: MOV B, 150 (Setup memory pointer in B) ---
        #2;
        $display("CHECK @ t=%0t: After MOV B, 150 -> regB = %d", $time, regB_out);
        if (regB_out !== 8'd150) begin
            $error("FAIL [AND A, (B)]: regB expected 150, got %d", regB_out);
            and_a_b_ind_test_failed = 1'b1;
        end

        // --- Step 5: AND A, (B) (Execute the bitwise AND) ---
        #2;
        // Expected result: 204 (11001100) & 170 (10101010) = 136 (10001000)
        $display("CHECK @ t=%0t: After AND A, (B) -> regA = %d", $time, regA_out);
        if (regA_out !== 8'd136) begin
            $error("FAIL [AND A, (B)]: regA expected 136, got %d", regA_out);
            and_a_b_ind_test_failed = 1'b1;
        end

        // --- Final Summary for this Test Block ---
        if (!and_a_b_ind_test_failed) begin
            $display(">>>>> AND A, (B) TEST PASSED! <<<<< ");
        end else begin
            $display(">>>>> AND A, (B) TEST FAILED! <<<<< ");
        end

        // --- Test: OR B, (Dir) ---
        $display("\n----- STARTING TEST: OR B, (0x10) [Direct Addressing] -----");

        // --- Step 1: MOV B, 195 (Setup first operand) ---
        #2;
        $display("CHECK @ t=%0t: After MOV B, 195 -> regB = %d", $time, regB_out);
        if (regB_out !== 8'd195) begin
            $error("FAIL [OR B, Dir]: regB expected 195, got %d", regB_out);
            or_b_dir_test_failed = 1'b1;
        end

        // --- Step 2: MOV A, 85 (Prepare value for memory) ---
        #2;
        $display("CHECK @ t=%0t: After MOV A, 85 -> regA = %d", $time, regA_out);
        if (regA_out !== 8'd85) begin
            $error("FAIL [OR B, Dir]: regA expected 85, got %d", regA_out);
            or_b_dir_test_failed = 1'b1;
        end

        // --- Step 3: MOV (16), A (Store value in memory) ---
        #2;
        $display("CHECK @ t=%0t: After MOV (16), A -> DM[16] = %d", $time, Comp.DM.mem[16]);
        if (Comp.DM.mem[16] !== 8'd85) begin
            $error("FAIL [OR B, Dir]: DM[16] expected 85, got %d", Comp.DM.mem[16]);
            or_b_dir_test_failed = 1'b1;
        end

        // --- Step 4: OR B, (16) (Execute the bitwise OR) ---
        #2;
        // Expected result: 195 (11000011) | 85 (01010101) = 215 (11010111)
        $display("CHECK @ t=%0t: After OR B, (16) -> regB = %d", $time, regB_out);
        if (regB_out !== 8'd215) begin
            $error("FAIL [OR B, Dir]: regB expected 215, got %d", regB_out);
            or_b_dir_test_failed = 1'b1;
        end

        // --- Final Summary for this Test Block ---
        if (!or_b_dir_test_failed) begin
            $display(">>>>> OR B, (Dir) TEST PASSED! <<<<< ");
        end else begin
            $display(">>>>> OR B, (Dir) TEST FAILED! <<<<< ");
        end

        // --- Test: NOT (B) ---
        $display("\n----- STARTING TEST: NOT (B) [Indirect Addressing] -----");

        // --- Step 1: MOV A, 165 (Setup source value) ---
        #2;
        $display("CHECK @ t=%0t: After MOV A, 165 -> regA = %d", $time, regA_out);
        if (regA_out !== 8'd165) begin
            $error("FAIL [NOT (B)]: regA expected 165, got %d", regA_out);
            not_b_ind_test_failed = 1'b1;
        end

        // --- Step 2: MOV B, 210 (Setup destination memory pointer) ---
        #2;
        $display("CHECK @ t=%0t: After MOV B, 210 -> regB = %d", $time, regB_out);
        if (regB_out !== 8'd210) begin
            $error("FAIL [NOT (B)]: regB expected 210, got %d", regB_out);
            not_b_ind_test_failed = 1'b1;
        end

        // --- Step 3: NOT (B) (Execute the bitwise NOT and store) ---
        #2;
        // Expected result in memory: ~165 (~10100101b) = 90 (01011010b)
        $display("CHECK @ t=%0t: After NOT (B) -> DM[210] = %d", $time, Comp.DM.mem[210]);
        if (Comp.DM.mem[210] !== 8'd90) begin
            $error("FAIL [NOT (B)]: DM[210] expected 90, got %d", Comp.DM.mem[210]);
            not_b_ind_test_failed = 1'b1;
        end

        // --- Final Summary for this Test Block ---
        if (!not_b_ind_test_failed) begin
            $display(">>>>> NOT (B) TEST PASSED! <<<<< ");
        end else begin
            $display(">>>>> NOT (B) TEST FAILED! <<<<< ");
        end

        // --- Test: XOR A, (Dir) ---
        $display("\n----- STARTING TEST: XOR A, (Dir) [Direct Addressing] -----");

        // --- Step 1: MOV A, 202 (Setup first operand) ---
        #2;
        $display("CHECK @ t=%0t: After MOV A, 202 -> regA = %d", $time, regA_out);
        if (regA_out !== 8'd202) begin
            $error("FAIL [XOR A, Dir]: regA expected 202, got %d", regA_out);
            xor_a_dir_test_failed = 1'b1;
        end

        // --- Step 2: MOV B, 172 (Prepare value for memory) ---
        #2;
        $display("CHECK @ t=%0t: After MOV B, 172 -> regB = %d", $time, regB_out);
        if (regB_out !== 8'd172) begin
            $error("FAIL [XOR A, Dir]: regB expected 172, got %d", regB_out);
            xor_a_dir_test_failed = 1'b1;
        end

        // --- Step 3: MOV (220), B (Store value in memory) ---
        #2;
        $display("CHECK @ t=%0t: After MOV (220), B -> DM[220] = %d", $time, Comp.DM.mem[220]);
        if (Comp.DM.mem[220] !== 8'd172) begin
            $error("FAIL [XOR A, Dir]: DM[220] expected 172, got %d", Comp.DM.mem[220]);
            xor_a_dir_test_failed = 1'b1;
        end

        // --- Step 4: XOR A, (220) (Execute the bitwise XOR) ---
        #2;
        // Expected result: 202 (11001010) ^ 172 (10101100) = 102 (01100110)
        $display("CHECK @ t=%0t: After XOR A, (220) -> regA = %d", $time, regA_out);
        if (regA_out !== 8'd102) begin
            $error("FAIL [XOR A, Dir]: regA expected 102, got %d", regA_out);
            xor_a_dir_test_failed = 1'b1;
        end

        // --- Final Summary for this Test Block ---
        if (!xor_a_dir_test_failed) begin
            $display(">>>>> XOR A, (Dir) TEST PASSED! <<<<< ");
        end else begin
            $display(">>>>> XOR A, (Dir) TEST FAILED! <<<<< ");
        end

        // --- Test: SHL (Dir), B ---
        $display("\n----- STARTING TEST: SHL (Dir), B [Direct Addressing] -----");

        // --- Step 1: MOV B, 85 (Setup source value) ---
        #2;
        $display("CHECK @ t=%0t: After MOV B, 85 -> regB = %d", $time, regB_out);
        if (regB_out !== 8'd85) begin
            $error("FAIL [SHL (Dir),B]: regB expected 85, got %d", regB_out);
            shl_dir_b_test_failed = 1'b1;
        end

        // --- Step 2: SHL (230), B (Execute the shift left and store) ---
        #2;
        // Expected result in memory: 85 (01010101b) << 1 = 170 (10101010b)
        $display("CHECK @ t=%0t: After SHL (230), B -> DM[230] = %d", $time, Comp.DM.mem[230]);
        if (Comp.DM.mem[230] !== 8'd170) begin
            $error("FAIL [SHL (Dir),B]: DM[230] expected 170, got %d", Comp.DM.mem[230]);
            shl_dir_b_test_failed = 1'b1;
        end

        // --- Final Summary for this Test Block ---
        if (!shl_dir_b_test_failed) begin
            $display(">>>>> SHL (Dir), B TEST PASSED! <<<<< ");
        end else begin
            $display(">>>>> SHL (Dir), B TEST FAILED! <<<<< ");
        end

        // --- Test: SHR (B) ---
        $display("\n----- STARTING TEST: SHR (B) [Indirect Addressing] -----");

        // --- Step 1: MOV A, 212 (Setup source value) ---
        #2;
        $display("CHECK @ t=%0t: After MOV A, 212 -> regA = %d", $time, regA_out);
        if (regA_out !== 8'd212) begin
            $error("FAIL [SHR (B)]: regA expected 212, got %d", regA_out);
            shr_b_ind_test_failed = 1'b1;
        end

        // --- Step 2: MOV B, 240 (Setup destination memory pointer) ---
        #2;
        $display("CHECK @ t=%0t: After MOV B, 240 -> regB = %d", $time, regB_out);
        if (regB_out !== 8'd240) begin
            $error("FAIL [SHR (B)]: regB expected 240, got %d", regB_out);
            shr_b_ind_test_failed = 1'b1;
        end

        // --- Step 3: SHR (B) (Execute the shift right and store) ---
        #2;
        // Expected result in memory: 212 (11010100b) >> 1 = 106 (01101010b)
        $display("CHECK @ t=%0t: After SHR (B) -> DM[240] = %d", $time, Comp.DM.mem[240]);
        if (Comp.DM.mem[240] !== 8'd106) begin
            $error("FAIL [SHR (B)]: DM[240] expected 106, got %d", Comp.DM.mem[240]);
            shr_b_ind_test_failed = 1'b1;
        end

        // --- Final Summary for this Test Block ---
        if (!shr_b_ind_test_failed) begin
            $display(">>>>> SHR (B) TEST PASSED! <<<<< ");
        end else begin
            $display(">>>>> SHR (B) TEST FAILED! <<<<< ");
        end

        // --- Test: INC (Dir) ---
        $display("\n----- STARTING TEST: INC (Dir) [Read-Modify-Write] -----");

        // --- Part 1: Standard Increment ---
        // Setup: Store 77 into DM[250]
        #4; // Wait for MOV A, 77 and MOV (250), A
        $display("CHECK @ t=%0t: After Setup 1 -> DM[250] = %d", $time, Comp.DM.mem[250]);
        if (Comp.DM.mem[250] !== 8'd77) begin
            $error("FAIL [INC (Dir)]: Setup failed, DM[250] expected 77, got %d", Comp.DM.mem[250]);
            inc_dir_test_failed = 1'b1;
        end

        // Execute INC (250)
        #2;
        // Expected result in memory: 77 + 1 = 78
        $display("CHECK @ t=%0t: After INC (250) -> DM[250] = %d", $time, Comp.DM.mem[250]);
        if (Comp.DM.mem[250] !== 8'd78) begin
            $error("FAIL [INC (Dir)]: DM[250] expected 78, got %d", Comp.DM.mem[250]);
            inc_dir_test_failed = 1'b1;
        end

        // --- Part 2: Overflow Test (255 -> 0) ---
        // Setup: Store 255 into DM[251]
        #4; // Wait for MOV A, 255 and MOV (251), A
        $display("CHECK @ t=%0t: After Setup 2 -> DM[251] = %d", $time, Comp.DM.mem[251]);
        if (Comp.DM.mem[251] !== 8'd255) begin
            $error("FAIL [INC (Dir)]: Setup failed, DM[251] expected 255, got %d", Comp.DM.mem[251]);
            inc_dir_test_failed = 1'b1;
        end

        // Execute INC (251)
        #2;
        // Expected result in memory: 255 + 1 = 0 (8-bit overflow)
        $display("CHECK @ t=%0t: After INC (251) [Overflow] -> DM[251] = %d", $time, Comp.DM.mem[251]);
        if (Comp.DM.mem[251] !== 8'd0) begin
            $error("FAIL [INC (Dir)]: DM[251] expected 0 after overflow, got %d", Comp.DM.mem[251]);
            inc_dir_test_failed = 1'b1;
        end

        // --- Final Summary for this Test Block ---
        if (!inc_dir_test_failed) begin
            $display(">>>>> INC (Dir) TEST PASSED! <<<<< ");
        end else begin
            $display(">>>>> INC (Dir) TEST FAILED! <<<<< ");
        end

        // --- Test: RST (B) ---
        $display("\n----- STARTING TEST: RST (B) [Indirect Addressing] -----");

        // --- Setup: Store a non-zero value (123) into DM[255] ---
        #4; // Wait for MOV A, 123 and MOV (255), A
        $display("CHECK @ t=%0t: After Setup -> DM[255] = %d", $time, Comp.DM.mem[255]);
        if (Comp.DM.mem[255] !== 8'd123) begin
            $error("FAIL [RST (B)]: Setup failed, DM[255] expected 123, got %d", Comp.DM.mem[255]);
            rst_b_ind_test_failed = 1'b1;
        end

        // --- Step 1: MOV B, 255 (Setup memory pointer) ---
        #2;
        $display("CHECK @ t=%0t: After MOV B, 255 -> regB = %d", $time, regB_out);
        if (regB_out !== 8'd255) begin
            $error("FAIL [RST (B)]: regB expected 255, got %d", regB_out);
            rst_b_ind_test_failed = 1'b1;
        end

        // --- Step 2: RST (B) (Execute the reset and store) ---
        #2;
        // Expected result in memory: 0
        $display("CHECK @ t=%0t: After RST (B) -> DM[255] = %d", $time, Comp.DM.mem[255]);
        if (Comp.DM.mem[255] !== 8'd0) begin
            $error("FAIL [RST (B)]: DM[255] expected 0, got %d", Comp.DM.mem[255]);
            rst_b_ind_test_failed = 1'b1;
        end

        // --- Final Summary for this Test Block ---
        if (!rst_b_ind_test_failed) begin
            $display(">>>>> RST (B) TEST PASSED! <<<<< ");
        end else begin
            $display(">>>>> RST (B) TEST FAILED! <<<<< ");
        end

        // --- Test: JLE - Case 2: A == Mem[B] ---
        $display("\n----- STARTING TEST: JLE - Case 2 (A == Mem[B]) -----");
        #20;
        $display("CHECK @ t=%0t: After JLE program (A == Mem[B]) -> DM[100] = %d", $time, Comp.DM.mem[100]);
        if (Comp.DM.mem[100] !== 8'd1) begin
            $error("FAIL [JLE Case 2]: DM[100] expected 1, got %d. Jump was not taken.", Comp.DM.mem[100]);
            jle_equal_test_failed = 1'b1;
        end
        if (!jle_equal_test_failed) $display(">>>>> JLE (A == Mem[B]) TEST PASSED! <<<<< ");
        else $display(">>>>> JLE (A == Mem[B]) TEST FAILED! <<<<< ");

        // --- Test: FOR Loop ---
        $display("\n----- STARTING TEST: FOR Loop (JGE, JMP) -----");

        // Calculate the exact execution time for the wait statement.
        // 2 setup instructions
        // + 4 successful loop iterations * 5 instructions/loop = 20 instructions
        // + 1 final failed loop check * 3 instructions = 3 instructions
        // + 1 final NOP instruction = 1 instruction
        // TOTAL = 26 instructions. @ 2 cycles/inst = 52 cycles.
        #52;

        $display("CHECK @ t=%0t: After FOR loop, verifying memory...", $time);

        // Check that the loop wrote the correct values to memory
        if (Comp.DM.mem[3] !== 8'd99) begin
            $error("FAIL [FOR Loop]: DM[3] expected 99, got %d", Comp.DM.mem[3]);
            for_loop_test_failed = 1'b1;
        end
        if (Comp.DM.mem[2] !== 8'd99) begin
            $error("FAIL [FOR Loop]: DM[2] expected 99, got %d", Comp.DM.mem[2]);
            for_loop_test_failed = 1'b1;
        end
        if (Comp.DM.mem[1] !== 8'd99) begin
            $error("FAIL [FOR Loop]: DM[1] expected 99, got %d", Comp.DM.mem[1]);
            for_loop_test_failed = 1'b1;
        end
        if (Comp.DM.mem[0] !== 8'd99) begin
            $error("FAIL [FOR Loop]: DM[0] expected 99, got %d", Comp.DM.mem[0]);
            for_loop_test_failed = 1'b1;
        end

        // Check that the loop terminated correctly and didn't write out of bounds
        if (Comp.DM.mem[4] !== 8'hx) begin // Assuming memory is initialized to x
            $error("FAIL [FOR Loop]: DM[4] should be unwritten, but has value %h.", Comp.DM.mem[4]);
            for_loop_test_failed = 1'b1;
        end

        // --- Final Summary for this Test Block ---
        if (!for_loop_test_failed) begin
            $display(">>>>> FOR Loop TEST PASSED! <<<<< ");
        end else begin
            $display(">>>>> FOR Loop TEST FAILED! <<<<< ");
        end

        #2;
        $finish;
    end

    // Clock Generator
    always #1 clk = ~clk;

endmodule