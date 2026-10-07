module controller(
    input  logic       clk,
    input  logic       reset,
    input  logic [6:0] op,
    input  logic [2:0] Funct3,
    input  logic       Funct7b5,
    input  logic       Zero,

    output logic [1:0] ImmSrc,
    output logic [1:0] ALUSrcA, 
    output logic [1:0] ALUSrcB,
    output logic [1:0] ResultSrc,
    output logic       AdrSrc,
    output logic [2:0] ALUControl,
    output logic       IRWrite, 
    output logic       PCWrite,
    output logic       RegWrite, 
    output logic       MemWrite
);

    logic [1:0] ALUOp;
    logic       PCUpdate;
    logic       Branch;

    typedef enum logic [3:0] {
        S_Fetch, 
        S_Decode, 
        S_MemAdr, 
        S_MemRead, 
        S_MemWB, 
        S_MemWrite, 
        S_ExecuteR, 
        S_ALUWB, 
        S_ExecuteI, 
        S_JAL, 
        S_BEQ
    } state_t;

    state_t state, next_state;

    always_ff @(posedge clk) begin 
        if (reset) begin
            state <= S_Fetch;
        end
        else begin
            state <= next_state;
        end
    end

    localparam logic [6:0]
        OP_LOAD     =   7'b0000011, //load word
        OP_STORE    =   7'b0100011,  //save word
        OP_RTYPE    =   7'b0110011, //R-type
        OP_ITYPE    =   7'b0010011, //I-type
        //OP_BRANCH   =   7'b1100011, //branch
        OP_JAL      =   7'b1101111, //jump and link
        OP_BEQ      =   7'b1100011; //branch equal

    
    localparam logic [1:0]
        ALUSrcA00       = 2'b00,
        ALUSrcA01       = 2'b01,
        ALUSrcA10       = 2'b10,

        ALUSrcB00       = 2'b00,
        ALUSrcB01       = 2'b01,
        ALUSrcB10       = 2'b10,

        ALUOp00         = 2'b00,
        ALUOp01         = 2'b01,
        ALUOp10         = 2'b10,

        ResultSrc00     = 2'b00,
        ResultSrc10     = 2'b10,
        ResultSrc01     = 2'b01;

    

    always_comb begin // next state logic
        case (state)

        

            S_Fetch:
                next_state = S_Decode;
            
            S_Decode: begin
                case (op)
                    OP_LOAD:    next_state  =    S_MemAdr;
                    OP_STORE:   next_state  =    S_MemAdr;
                    OP_RTYPE:   next_state  =    S_ExecuteR;
                    OP_ITYPE:   next_state  =    S_ExecuteI;
                    OP_JAL:     next_state  =    S_JAL;
                    OP_BEQ:     next_state  =    S_BEQ;
                    default:    next_state  =    S_Fetch;
                endcase
            end

            S_MemAdr: begin
                case (op)
                    OP_LOAD:    next_state  =    S_MemRead;
                    OP_STORE:   next_state  =    S_MemWrite;
                    default:    next_state  =    S_Fetch;
                endcase
            end

            S_MemRead: 
                next_state = S_MemWB;

            S_MemWB: 
                next_state = S_Fetch;
            
            S_MemWrite: 
                next_state = S_Fetch;
            
            S_ExecuteR:
                next_state = S_ALUWB;
            
            S_ALUWB:
                next_state = S_Fetch;
            
            S_ExecuteI:
                next_state = S_ALUWB;
            
            S_JAL:
                next_state = S_ALUWB;

            S_BEQ:
                next_state = S_Fetch;
        
        default: next_state = S_Fetch;
        endcase
    end

    always_comb begin // output signals

        AdrSrc    = 1'b0;
        IRWrite   = 1'b0;
        PCUpdate  = 1'b0;
        RegWrite  = 1'b0;
        MemWrite  = 1'b0;
        Branch    = 1'b0;

        ALUSrcA   = 2'b00;
        ALUSrcB   = 2'b00;
        ALUOp     = 2'b00;
        ResultSrc = 2'b00;

        case (state)

            S_Fetch: begin // 0 
                AdrSrc      = 1'b0;
                IRWrite     = 1'b1;
                ALUSrcA     = ALUSrcA00;
                ALUSrcB     = ALUSrcB10;
                ALUOp       = ALUOp00;
                ResultSrc   = ResultSrc10;
                PCUpdate    = 1'b1;
            end

            S_Decode: begin // 1
                ALUSrcA     = ALUSrcA01;
                ALUSrcB     = ALUSrcB01;
                ALUOp       = ALUOp00;
            end

            S_MemAdr: begin // 2
                ALUSrcA     = ALUSrcA10;
                ALUSrcB     = ALUSrcB01;
                ALUOp       = ALUOp00;
            end

            S_MemRead: begin // 3
                ResultSrc   = ResultSrc00;
                AdrSrc      = 1'b1;
            end

            S_MemWB: begin // 4
                ResultSrc   = ResultSrc01;
                RegWrite    = 1'b1;
            end

            S_MemWrite: begin // 5
                ResultSrc   = ResultSrc00;
                AdrSrc      = 1'b1;
                MemWrite    = 1'b1;
            end

            S_ExecuteR: begin // 6
                ALUSrcA     = ALUSrcA10;
                ALUSrcB     = ALUSrcB00;
                ALUOp       = ALUOp10;
            end

            S_ALUWB: begin // 7
                ResultSrc   = ResultSrc00;
                RegWrite    = 1'b1;
            end

            S_ExecuteI: begin // 8
                ALUSrcA     = ALUSrcA10;
                ALUSrcB     = ALUSrcB01;
                ALUOp       = ALUOp10;
            end

            S_JAL: begin // 9
                ALUSrcA     = ALUSrcA01;
                ALUSrcB     = ALUSrcB10;
                ALUOp       = ALUOp00;
                ResultSrc   = ResultSrc00;
                PCUpdate    = 1'b1;
            end

            S_BEQ: begin // 10
                ALUSrcA     = ALUSrcA10;
                ALUSrcB     = ALUSrcB00;
                ALUOp       = ALUOp01;
                ResultSrc   = ResultSrc00;
                Branch      = 1'b1;
            end

            default: ;
        endcase
    end
    
    always_comb begin // ALUControl logic
        case (ALUOp)
            
            
            ALUOp00: ALUControl = 3'b000; // add
            ALUOp01: ALUControl = 3'b001; // sub
            ALUOp10: begin
                case (Funct3)
                    3'b000: begin
                        if (op[5] & Funct7b5) 
                            ALUControl  =   3'b001; // sub 
                        else 
                            ALUControl  =   3'b000; // add
                    end
                    3'b111: ALUControl  =   3'b010; // and
                    3'b110: ALUControl  =   3'b011; // or
                    3'b010: ALUControl  =   3'b101; // slt
                    default: ALUControl =   3'b000; // undefined
                endcase
            end
            default: ALUControl = 3'b000; // undefined
        endcase
    end

    always_comb begin // ImmSrc logic
        ImmSrc  =   2'b00; // undefined
        case (op)
            OP_LOAD:    ImmSrc  =   2'b00; // I-type
            OP_STORE:   ImmSrc  =   2'b01; // S-type
            OP_ITYPE:   ImmSrc  =   2'b00; // I-type
            OP_BEQ:     ImmSrc  =   2'b10; // B-type
            OP_JAL:     ImmSrc  =   2'b11; // J-type
            default:    ImmSrc  =   2'b00; // undefined
        endcase
    end
    assign PCWrite = PCUpdate | (Branch & Zero);

endmodule


