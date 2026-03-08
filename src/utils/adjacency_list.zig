const std = @import("std");

pub fn AdjacencyList(comptime weighted: bool) type {
    const Edge = if (weighted) {
        struct { to: u32, weight: i64 };
    } else {
        struct { to: u32 };
    };
    
    return struct {
        const Self = @This();
        
        neighbors: std.ArrayList(std.ArrayList(Edge)),
        directed: bool,
        allocator: std.mem.Allocator,
        
        pub fn init(allocator: std.mem.Allocator, num_vertices: u32, directed: bool) !Self {
            const neighbors = try std.ArrayList(std.ArrayList(Edge)).initCapacity(allocator, @as(usize, num_vertices));
            for (neighbors.items) |*list| {
                list.* = std.ArrayList(Edge).initCapacity(allocator, 1);
            }
            
            return Self {
                .neighbors = neighbors,
                .directed = directed,
                .allocator = allocator
            };
        }
        
        pub fn addEdge(self: *Self, from: u32, to: u32, weight: if (weighted) i64 else void) !void {
            if (weighted) {
                try self.neighbors.items[from].append(self.allocator, .{
                    .to = to,
                    .weight = weight,
                });
                if (!self.directed) {
                    try self.neighbors.items[to].append(self.allocator, .{
                        .to = from,
                        .weight = weight,
                    });
                }
            } else {
                try self.neighbors.append(self.allocator, .{
                    .to = to,
                });
                if (!self.directed) {
                    try self.neighbors.items[to].append(self.allocator, .{
                        .to = from 
                    });
                }
            }
        }
        
        pub fn getNeighbors(self: *const Self, vertex: u32) []const Edge {
            return self.neighbors.items[vertex].items;
        }
        
        pub fn deinit(self: *Self) void {
            for (self.neighbors.items) |*list| {
                list.deinit(self.allocator);
            }
            self.neighbors.deinit(self.allocator);
        }
    };
}