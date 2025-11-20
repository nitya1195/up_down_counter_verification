// Code your testbench here
// or browse Examples
​
module tb;
    reg clk = 0, rst = 1, up_down, enable;
    wire [3:0] count;
​
    up_down_counter dut (.*);
​
    always #5 clk = ~clk;
​
    // === MANUAL COVERAGE: Use reg arrays (Icarus-safe) ===
    reg [15:0] count_covered;
    reg [3:0] en_dir_covered;
​
    // Sample on clock
    always @(posedge clk) begin
        if (!rst) begin
            count_covered[count] = 1'b1;
            en_dir_covered[{enable, up_down}] = 1'b1;
        end
    end
​
    initial begin
        count_covered = 16'b0;
        en_dir_covered = 4'b0;
​
        $display("=== Up/Down Counter Test with Manual Coverage ===");
        rst = 1;
        #15 rst = 0;
​
        repeat(100) begin
            enable  = $random % 2;
            up_down = $random % 2;
            #10;
        end
​
        #20;
        $display("Final count = %0d", count);
​
        // === COVERAGE REPORT ===
        begin : coverage_report
            integer i, covered_count, covered_combos;
            covered_count = 0;
            covered_combos = 0;
​
            for (i = 0; i < 16; i = i + 1)
                if (count_covered[i]) covered_count = covered_count + 1;
​
            for (i = 0; i < 4; i = i + 1)
                if (en_dir_covered[i]) covered_combos = covered_combos + 1;
​
            $display("Count Coverage: %0d/16 (%.2f%%)", 
                     covered_count, (covered_count * 100.0)/16);
            $display("Enable+Dir Coverage: %0d/4 (%.2f%%)", 
                     covered_combos, (covered_combos * 100.0)/4);
            $display("Total Functional Coverage: %.2f%%", 
                     ((covered_count * 100.0)/16 + (covered_combos * 100.0)/4)/2);
        end : coverage_report
​
        $finish;
    end
​
    initial 
        $monitor("t=%0t | rst=%b en=%b dir=%b | count=%0d", 
                 $time, rst, enable, up_down, count);
endmodule
