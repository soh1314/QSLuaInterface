//
//  ViewController.m
//  LuaOCInterFace
//
//  Created by user on 2017/4/14.
//  Copyright © 2017年 user. All rights reserved.
//

#import "ViewController.h"

#include "stdio.h"
#include <lua.h>
#include <lauxlib.h>
#include <lualib.h>

static lua_State* L = NULL;

// 内部调用lua函数
NSInteger f(double x)
{
    NSInteger z;
    lua_getglobal(L, "add");    // 获取lua函数f
    lua_pcall(L, 0, 1, 0);
//        error(L, "error running function 'f': %s", lua_tostring(L, -1));

//        error(L, "function 'f' must return a number");
    z = lua_tointeger(L, -1);
    lua_pop(L, 1);
    return z;
}


void ocprint() {
    lua_getglobal(L,"printK");
    lua_pcall(L,0,0,0);
}
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    lua_State *L =luaL_newstate();
//    luaL_openlibs(L);
//    luaL_dofile(L,"/Users/user/Desktop/file.lua");
//    lua_close(L);
    L = luaL_newstate();
    luaL_openlibs(L);
    lua_settop(L, 0);
    NSString *luaFilePath = [[NSBundle mainBundle] pathForResource:@"file" ofType:@"lua"];
    NSString *luaContent = [NSString stringWithContentsOfFile:luaFilePath
                                                     encoding:NSUTF8StringEncoding
                                                        error:nil];
    
    int err;
    if (luaContent == nil || [luaContent isEqualToString: @""]) {
        NSLog(@"Lua_State initial fail，lua file is nil");
    }else {
        err = luaL_loadstring(L, [luaContent cStringUsingEncoding: NSUTF8StringEncoding]);
        if (0 != err) {
            luaL_error(L, "cannot compile the lua file: %s",
                       lua_tostring(L, -1));
            return;
        }
        
        err = lua_pcall(L, 0, 0, 0);
        if (0 != err) {
            luaL_error(L, "cannot run the lua file: %s",
                       lua_tostring(L, -1));
            return;
        }
        
        NSLog(@"Lua_state initial success");
    }
//    if( || lua_pcall(L, 0, 0, 0))
//        error(L, "cannot run configuration file: %s", lua_tostring(L, -1));
    ocprint();
    NSLog(@"%d",f(5));

    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
