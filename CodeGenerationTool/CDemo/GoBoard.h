#ifndef GO_BOARD_H_INCLUDED
#define GO_BOARD_H_INCLUDED


//最大棋盘19，定义21原因是留出棋盘外围，方便使用（数组不越界）
#define MAX_BOARDSIZE 21
//最长对局411手，为方便使用棋子信息数据中下标0未使用
#define MAX_STONENUMBER 412

//布尔
typedef enum tag_BOOL
{
    false,
    true
} bool;

//棋盘交叉点连接方向
typedef enum tag_Direction
{
    SIDE_NONE  = 0,
    SIDE_LEFT  = 1,      //二进制 0001
    SIDE_RIGHT = 2,      //二进制 0010
    SIDE_UP    = 4,      //二进制 0100
    SIDE_DOWN  = 8,      //二进制 1000
    SIDE_ALL   = 15      //二进制 1111
} DIRECTION;
//判断状态 a 中是否包含特定值 b
#define HaveThisState(a, b) ((a & b) == b)
//判断状态 a 中是否不包含特定值 b
#define NoThisState(a, b) ((a & b) != b)

//棋子颜色
typedef enum tag_StoneColor
{
    GREY = -1,     //棋盘外围
    EMPTY,         //无子
    BLACK,         //黑色
    WHITE          //白色
} STONECOLOR;
//反色：黑变白，白变黑
#define OtherColor(c) (BLACK + WHITE - c)

//棋盘上每一个交叉点的状态
typedef struct tagBoardData
{
    STONECOLOR c;  //该位棋子颜色
    int n;         //该位棋子手数：0 无子，1-n 手数
} BOARDDATA;
//坐标整合与分解
#define MAKESITE(x, y) (x*MAX_BOARDSIZE+y)
#define XPOINT(p) (p/MAX_BOARDSIZE)
#define YPOINT(p) (p%MAX_BOARDSIZE)

//每一手棋子的信息
typedef struct tagStoneData
{
    unsigned char x;         //坐标
    unsigned char y;
    STONECOLOR c;  //颜色
    int n;         //手数
    int sn;        //显示手数：0 无子或固定子，1-n 显示手数数字
    int ko;        //吃子数
    int bk;        //被吃手数
} STONEDATA;


extern int g_iBoardSize;                                   //棋盘线数
extern BOARDDATA g_BoardData[MAX_BOARDSIZE*MAX_BOARDSIZE];//棋盘状态数据

extern int g_iStoneNumber, g_iShowStoneNumber;             //棋子总手数、总显示数
extern STONECOLOR g_cNextColor;                            //下一手棋的颜色
extern STONEDATA g_StoneData[MAX_STONENUMBER];             //棋子信息数据

extern int g_iBackStoneNumber;               			   //棋子备份总手数
extern STONEDATA g_BackStoneData[MAX_STONENUMBER];         //备份棋子信息数据

extern int g_iTempStoneNumber;               			   //临时棋子备份总手数

extern STONECOLOR g_BoardExam0[MAX_BOARDSIZE*MAX_BOARDSIZE];//点目状态各交叉点真实棋子颜色
extern STONECOLOR g_BoardExam2[MAX_BOARDSIZE*MAX_BOARDSIZE];//点目状态各交叉点所属颜色


//鉴于棋盘状态对棋子信息的引用，清空时一定要注意：
//先清空棋盘状态数据，再清棋子信息数据
extern void ClearBoardData(void);                  			   //清空棋盘交叉点状态数据
extern void ClearStoneData(void);                              //清空棋子信息数据
extern void CopyStoneData(void);				           //复制棋子信息数据

extern void InitBoardExam0(void);                              //点目状态数据初始化
extern void InvertBoardExam0(unsigned char, unsigned char);//改变点目状态各交叉点真实棋子颜色
extern void ScanBoardExam(int *, int *, int *);            //全盘扫描，取得黑白各色子数

extern int GetLiberty(unsigned char, unsigned char, STONECOLOR);     //计算棋盘交叉点上棋子的气数

extern int PlayStone(unsigned char, unsigned char, STONECOLOR, bool);//落下一手棋
extern bool WithdrawOneStep(void);                                   //悔棋一步


#endif // GO_BOARD_H_INCLUDED
