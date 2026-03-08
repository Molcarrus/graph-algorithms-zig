const std = @import("std");

pub fn AdjacentMatrix(comptime T: type) type {
    return struct {
        const Self = @This();
        const NO_EDGE = std.math.maxInt(T);
        
        data: []T,
        size: u32,
        directed: bool,
        allocator: std.mem.Allocator,
        
        pub fn init(allocator: std.mem.Allocator, num_vertices: u32, directed: bool) !Self {
            const total = @as(usize, num_vertices) * @as(usize, num_vertices);
            const data = try allocator.alloc(T, total);
            @memset(data, NO_EDGE);
            
            return Self {
                .data = data,
                .size = num_vertices,
                .directed = directed,
                .allocator = allocator,
            };
        }
        
        pub fn addEdge(self: *Self, from: u32, to: u32, weight: T) void {
            self.data[@as(usize, from) * self.size + to] = weight;
            if (!self.directed) {
               self.data[@as(usize, to) * self.size + from] = weight;
           } 
        }
        
        pub fn getEdge(self: *const Self, from: u32, to: u32) ?T {
            const val = self.data[@as(usize, from) * self.size + to];
            return if (val == NO_EDGE) null else val;
        }
        
        pub fn hasEdge(self: *const Self, from: u32, to: u32) bool {
            return self.getEdge(from, to);
        }
        
        pub fn deinit(self: *Self) void {
            self.allocator.free(self.data);
        }
    };
}