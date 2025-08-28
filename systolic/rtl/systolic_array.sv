// Systolic Processing Element (PE)
module systolic_pe #(
    parameter int DATAWIDTH = 16
)(
    input  logic                         clk,
    input  logic                         rst_n,
    input  logic signed [DATAWIDTH-1:0]  a_left,
    input  logic signed [DATAWIDTH-1:0]  b_top,
    output logic signed [DATAWIDTH-1:0]  a_right,
    output logic signed [DATAWIDTH-1:0]  b_bottom,
    output logic signed [2*DATAWIDTH-1:0] final_result
);
    logic signed [2*DATAWIDTH-1:0] accumulator;
    assign final_result = accumulator;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            a_right     <= '0;
            b_bottom    <= '0;
            accumulator <= '0;
        end else begin
            a_right     <= a_left;
            b_bottom    <= b_top;
            accumulator <= accumulator + (a_left * b_top);
        end
    end
endmodule


// Complete systolic array module with fixed input distribution logic
module systolic_array #(
    parameter integer DATAWIDTH = 16,
    parameter integer N_SIZE    = 5
)(
    input  wire                           clk,
    input  wire                           rst_n,
    input  wire                           valid_in,
    input  wire signed [N_SIZE*DATAWIDTH-1:0] matrix_a_in,
    input  wire signed [N_SIZE*DATAWIDTH-1:0] matrix_b_in,
    output logic                           valid_out,
    output logic signed [N_SIZE*2*DATAWIDTH-1:0] matrix_c_out
);

    wire signed [DATAWIDTH-1:0] a_bus [0:N_SIZE][0:N_SIZE-1];
    wire signed [DATAWIDTH-1:0] b_bus [0:N_SIZE-1][0:N_SIZE];
    wire signed [2*DATAWIDTH-1:0] result_bus [0:N_SIZE-1][0:N_SIZE-1];

    // Delay counter for input timing
    reg [$clog2(2*N_SIZE):0] delay;
    reg valid_d;
    reg [$clog2(N_SIZE+2):0] c;

    // Helper wires for bit slicing
    wire signed [DATAWIDTH-1:0] a_slice [0:N_SIZE-1];
    wire signed [DATAWIDTH-1:0] b_slice [0:N_SIZE-1];
    
    // Generate constant bit slicing
    genvar k;
    generate
        for (k = 0; k < N_SIZE; k = k + 1) begin : SLICE_GEN
            assign a_slice[k] = matrix_a_in[(k+1)*DATAWIDTH-1:k*DATAWIDTH];
            assign b_slice[k] = matrix_b_in[(k+1)*DATAWIDTH-1:k*DATAWIDTH];
        end
    endgenerate

    genvar i, j;
    generate
        for (i = 0; i < N_SIZE; i = i + 1) begin : INPUT_CONNECTIONS
            // Matrix A input (left edge)
            assign a_bus[i][0] = valid_in ? matrix_a_in[(i+1)*DATAWIDTH-1:i*DATAWIDTH] : '0;
            // Matrix B input (top edge)
            assign b_bus[0][i] = valid_in ? matrix_b_in[(i+1)*DATAWIDTH-1:i*DATAWIDTH] : '0;
        end
    endgenerate

    // Generate systolic PE array
    generate
        for (i = 0; i < N_SIZE; i = i+1) begin : ROWS
            for (j = 0; j < N_SIZE; j = j+1) begin : COLS
                systolic_pe #(
                    .DATAWIDTH(DATAWIDTH)
                ) pe_inst (
                    .clk         (clk),
                    .rst_n       (rst_n),
                    .a_left      (a_bus[i][j]),
                    .b_top       (b_bus[i][j]),
                    .a_right     (a_bus[i][j+1]),
                    .b_bottom    (b_bus[i+1][j]),
                    .final_result(result_bus[i][j])
                );
            end
        end
    endgenerate

    // Simplified control logic without procedural loops
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            valid_d <= 1'b0;
            delay <= 1;
            c <= N_SIZE+1; 
        end
        else if (valid_in) begin
            if (delay < 2*N_SIZE-1) begin
                delay <= delay + 1;
            end
            else if (delay == 2*N_SIZE-1) begin
                delay <= N_SIZE+1;
            end
            valid_d <= 1'b0;
            c <= N_SIZE+1;
        end
        else if (delay == N_SIZE+1) begin
            if (c > 1) begin
                c <= c-1;
                valid_d <= 1'b1;
            end
            else begin
                delay <= 1;
                valid_d <= 1'b0;
                c <= N_SIZE+1;
            end        
        end
    end

    assign valid_out = valid_d;

    // Simple output assignment using case statement
    generate
        for (j = 0; j < N_SIZE; j = j + 1) begin : OUTPUT_COL
            logic signed [2*DATAWIDTH-1:0] selected_result;
            
            always_comb begin
                if (!valid_out) begin
                    selected_result = '0;
                end else begin
                    case (c)
                        1: selected_result = (N_SIZE >= 1) ? result_bus[N_SIZE-1][j] : '0;
                        2: selected_result = (N_SIZE >= 2) ? result_bus[N_SIZE-2][j] : '0;
                        3: selected_result = (N_SIZE >= 3) ? result_bus[N_SIZE-3][j] : '0;
                        4: selected_result = (N_SIZE >= 4) ? result_bus[N_SIZE-4][j] : '0;
                        5: selected_result = (N_SIZE >= 5) ? result_bus[N_SIZE-5][j] : '0;
                        6: selected_result = (N_SIZE >= 6) ? result_bus[N_SIZE-6][j] : '0;
                        7: selected_result = (N_SIZE >= 7) ? result_bus[N_SIZE-7][j] : '0;
                        8: selected_result = (N_SIZE >= 8) ? result_bus[N_SIZE-8][j] : '0;
                        default: selected_result = '0;
                    endcase
                end
            end
            
            assign matrix_c_out[j*2*DATAWIDTH +: 2*DATAWIDTH] = selected_result;
        end
    endgenerate

endmodule