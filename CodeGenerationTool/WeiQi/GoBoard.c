#include <string.h>
#include "GoBoard.h"


int g_iBoardSize = 19;                                //棋盘线数
BOARDDATA g_BoardData[MAX_BOARDSIZE*MAX_BOARDSIZE];   //棋盘状态数据

int g_iStoneNumber, g_iShowStoneNumber;               //棋子总手数、总显示数
STONECOLOR g_cNextColor = BLACK;                      //下一手棋的颜色
STONEDATA g_StoneData[MAX_STONENUMBER];               //棋子信息数据

int g_iBackStoneNumber;               				  //棋子备份总手数
STONEDATA g_BackStoneData[MAX_STONENUMBER];           //备份棋子信息数据

int g_iTempStoneNumber;               				  //临时棋子备份总手数

STONECOLOR g_BoardExam0[MAX_BOARDSIZE*MAX_BOARDSIZE];          //点目状态各交叉点真实棋子颜色
STONECOLOR g_BoardExam2[MAX_BOARDSIZE*MAX_BOARDSIZE];          //点目状态各交叉点所属颜色
static STONECOLOR g_BoardExam1[MAX_BOARDSIZE*MAX_BOARDSIZE];   //点目状各色棋子边线

static DIRECTION g_HaveCount[MAX_BOARDSIZE*MAX_BOARDSIZE];     //算气、寻找同色子的方向标志
static bool g_NoLiberty[MAX_BOARDSIZE*MAX_BOARDSIZE];          //算气的死活标志


static int Count(unsigned char, unsigned char, STONECOLOR);
static int CheckLastStone(void);

static void FindSameInBoardExam0(unsigned char, unsigned char, STONECOLOR, bool);
static STONECOLOR DecideCrossColor(unsigned char, unsigned char, STONECOLOR *p);

static void AddOneStone(unsigned char, unsigned char, STONECOLOR, bool);
static void DeleteLastStone(void);


//清空棋盘状态数据
extern void ClearBoardData(void)
{
    unsigned char i, j;

    //棋盘内数据全部归0
    memset(g_BoardData, 0, sizeof(g_BoardData));
    //棋盘外围颜色赋 -1
    j = g_iBoardSize+1;
    for(i=0; i<=j; i++)
    {
        g_BoardData[i].c = GREY;
        g_BoardData[MAKESITE(j, i)].c = GREY;
        g_BoardData[MAKESITE(i, 0)].c = GREY;
        g_BoardData[MAKESITE(i, j)].c = GREY;
    }
}

//清空棋子信息数据
extern void ClearStoneData(void)
{
    g_iStoneNumber = g_iShowStoneNumber = 0;
    g_cNextColor = BLACK;
    memset(g_StoneData, 0, sizeof(g_StoneData));
}

//拷贝棋子信息数据
extern void CopyStoneData(void)
{
    g_iBackStoneNumber = g_iStoneNumber;
    memcpy(g_BackStoneData, g_StoneData, sizeof(STONEDATA)*MAX_STONENUMBER);
}

//扫描 g_BoardExam，取得黑白各色子数
extern void ScanBoardExam(int *b, int *w, int *e)
{
    unsigned char i, j;

    *b = *w = *e = 0;

    //由真实棋子确定各色区域线
    for(i=1; i<=g_iBoardSize; i++)
        for(j=1; j<=g_iBoardSize; j++)
            g_BoardExam1[MAKESITE(i, j)] = DecideCrossColor(i, j, g_BoardExam0);

    //确定各色区域线内空格归属该色
    for(i=1; i<=g_iBoardSize; i++)
        for(j=1; j<=g_iBoardSize; j++)
            g_BoardExam2[MAKESITE(i, j)] = DecideCrossColor(i, j, g_BoardExam1);

    //扫描全盘数子
    for(i=1; i<=g_iBoardSize; i++)
        for(j=1; j<=g_iBoardSize; j++)
        {
            if(g_BoardExam2[MAKESITE(i, j)] == BLACK)
                (*b)++;
            else if(g_BoardExam2[MAKESITE(i, j)] == WHITE)
                (*w)++;
            else
                (*e)++;
        }
}

//初始化点目状态各交叉点真实棋子颜色
extern void InitBoardExam0(void)
{
    unsigned char i, j;
    //盘面棋子
    for(i=1; i<=g_iBoardSize; i++)
        for(j=1; j<=g_iBoardSize; j++)
            g_BoardExam0[MAKESITE(i, j)] = g_BoardData[MAKESITE(i, j)].c;
}

//初始化 g_BoardExam0
extern void InvertBoardExam0(unsigned char x, unsigned char y)
{
    memset(g_HaveCount, SIDE_NONE, sizeof(g_HaveCount));
    g_BoardExam0[MAKESITE(x, y)] = OtherColor(g_BoardExam0[MAKESITE(x, y)]);
    FindSameInBoardExam0(x, y, g_BoardData[MAKESITE(x, y)].c, g_BoardExam0[MAKESITE(x, y)]!=g_BoardData[MAKESITE(x, y)].c);
}

//改变点目状态各交叉点真实棋子颜色
//用2进制位表示状态：0没算过 *1算过左边  *2算过右边 *4算过上边 *8算过下边
static void FindSameInBoardExam0(unsigned char x, unsigned char y, STONECOLOR c, bool b)
{
    unsigned char i;

    //棋盘外围，或者全部算完
    if(x<1 || x>g_iBoardSize || y<1 || y>g_iBoardSize || HaveThisState(g_HaveCount[MAKESITE(x, y)], SIDE_ALL))
        return;

    //算左边一子
    if(NoThisState(g_HaveCount[MAKESITE(x, y)], SIDE_LEFT))
    {
        g_HaveCount[MAKESITE(x, y)] |= SIDE_LEFT;                      //给左边已找过的标志
        i = x -1;                                            //左边子
        if(i>0)                                              //左边子没超出正常棋盘范围
        {
            if(g_BoardData[MAKESITE(i, y)].c == c)                     //左边子同色，继续往左找
            {
                g_HaveCount[MAKESITE(i, y)] |= SIDE_RIGHT;             //左边子不需往右边找
                g_BoardExam0[MAKESITE(i, y)] = b ? OtherColor(c) : c;
                FindSameInBoardExam0(i, y, c, b);
            }
        }
    }
    //算右边一子
    if(NoThisState(g_HaveCount[MAKESITE(x, y)], SIDE_RIGHT))
    {
        g_HaveCount[MAKESITE(x, y)] |= SIDE_RIGHT;
        i = x + 1;
        if(i<=g_iBoardSize)
        {
            if(g_BoardData[MAKESITE(i, y)].c == c)
            {
                g_HaveCount[MAKESITE(i, y)] |= SIDE_LEFT;
                g_BoardExam0[MAKESITE(i, y)] = b ? OtherColor(c) : c;
                FindSameInBoardExam0(i, y, c, b);
            }
        }
    }
    //算上边一子
    if(NoThisState(g_HaveCount[MAKESITE(x, y)], SIDE_UP))
    {
        g_HaveCount[MAKESITE(x, y)] |= SIDE_UP;
        i = y - 1;
        if(i>0)
        {
            if(g_BoardData[MAKESITE(x, i)].c == c)
            {
                g_HaveCount[MAKESITE(x, i)] |= SIDE_DOWN;
                g_BoardExam0[MAKESITE(x, i)] = b ? OtherColor(c) : c;
                FindSameInBoardExam0(x, i, c, b);
            }
        }
    }
    //算下边一子
    if(NoThisState(g_HaveCount[MAKESITE(x, y)], SIDE_DOWN))
    {
        g_HaveCount[MAKESITE(x, y)] |= SIDE_DOWN;
        i = y + 1;
        if(i<=g_iBoardSize)
        {
            if(g_BoardData[MAKESITE(x, i)].c == c)
            {
                g_HaveCount[MAKESITE(x, i)] |= SIDE_UP;
                g_BoardExam0[MAKESITE(x, i)] = b ? OtherColor(c) : c;
                FindSameInBoardExam0(x, i, c, b);
            }
        }
    }
}

//点目状态确定空格位置归属颜色
static STONECOLOR DecideCrossColor(unsigned char x, unsigned char y, STONECOLOR *p)
{
    STONECOLOR c[4], r = EMPTY;
    unsigned char i;

    //交叉点有棋子
    if(p[MAKESITE(x, y)] != EMPTY)
        return p[MAKESITE(x, y)];
    //交叉点为空格，则判断其4个方向相邻最近子的颜色
    //向左检查
    i = x;
    while(p[MAKESITE(i, y)] == EMPTY && i > 0)
        i--;
    c[0] = p[MAKESITE(i, y)];
    //向右检查
    i = x;
    while(p[MAKESITE(i, y)] == EMPTY && i <= g_iBoardSize)
        i++;
    c[1] = p[MAKESITE(i, y)];
    //向上检查
    i = y;
    while(p[MAKESITE(x, i)] == EMPTY && i > 0)
        i--;
    c[2] = p[MAKESITE(x, i)];
    //向下检查
    i = y;
    while(p[MAKESITE(x, i)] == EMPTY && i <= g_iBoardSize)
        i++;
    c[3] = p[MAKESITE(x, i)];
    //该空格相邻4个方向最近子的颜色一致，且不都是空格，则该空格属于该色，否则作为公气
    for(i=0; i<4; i++)
        if(c[i] != EMPTY)
        {
            r = c[i];
            break;
        }
    for(i=0; i<4; i++)
        if(c[i] != EMPTY && c[i] != r)
            return EMPTY;
    return r;
}

//落下一手棋
//参数：x y 棋盘逻辑坐标，c 落子颜色，b 是否增加显示手数
//返回值：有效则返回吃子数，禁手（包括打劫）返回-1 ，当前点有子返回-2
extern int PlayStone(unsigned char x, unsigned char y, STONECOLOR c, bool b)
{
    int i;

    //点击非空位
    if(g_BoardData[MAKESITE(x, y)].c != EMPTY)
        return -2;

    //先增加一子
    AddOneStone(x, y, c, b);
    //检查有效性（有效时已经更新数据 ）
    i = CheckLastStone();
    if(i >= 0)
    {
        //增加显示手数的话是正常落子，需要改变下一手的颜色
        if(b) g_cNextColor = OtherColor(g_cNextColor);
        return i;
    }
    else    //无效再删掉
    {
        DeleteLastStone();
        return -1;
    }
}

//回退一步
//返回值：成功返回1，否则返回0
extern bool WithdrawOneStep(void)
{
    if(g_iStoneNumber > 0)
    {
        //把最后一子吃掉的棋还原
        int i;
        for(i=1; i<g_iStoneNumber; i++)
            if(g_StoneData[i].bk == g_iStoneNumber)
            {
                g_StoneData[i].bk = 0;
                g_BoardData[MAKESITE(g_StoneData[i].x, g_StoneData[i].y)].n = g_StoneData[i].n;
                g_BoardData[MAKESITE(g_StoneData[i].x, g_StoneData[i].y)].c = g_StoneData[i].c;
            }
        //下一手变色，悔棋为固定子则不变
        if(g_StoneData[g_iStoneNumber].sn>0)
            g_cNextColor =  g_iStoneNumber>0 ? OtherColor(g_cNextColor) : BLACK;
        //删掉最后一子
        DeleteLastStone();
        return true;
    }
    return false;
}

//获得气
//参数：x y 棋盘的逻辑坐标，c 棋子颜色
//返回值：x y点所在C颜色棋块的气数
extern int GetLiberty(unsigned char x, unsigned char y, STONECOLOR c)
{
    //算气的标志位归 1
    memset(g_HaveCount, SIDE_NONE, sizeof(g_HaveCount));
    return Count(x, y, c);
}

//增加一子
//参数：x,y 棋子在棋盘上的坐标，c 棋子颜色，b 是否计显示手数
//谨慎使用，本函数不做合理性校验
static void AddOneStone(unsigned char x, unsigned char y, STONECOLOR c, bool b)
{
    g_iStoneNumber++;

    g_StoneData[g_iStoneNumber].x = x;
    g_StoneData[g_iStoneNumber].y = y;
    g_StoneData[g_iStoneNumber].c = c;
    g_StoneData[g_iStoneNumber].n = g_iStoneNumber;
    if(b)
    {
        g_iShowStoneNumber++;
        g_StoneData[g_iStoneNumber].sn = g_iShowStoneNumber;
    }
    else
        g_StoneData[g_iStoneNumber].sn = 0;
    g_StoneData[g_iStoneNumber].ko = 0;
    g_StoneData[g_iStoneNumber].bk = 0;

    g_BoardData[MAKESITE(x, y)].c = c;
    g_BoardData[MAKESITE(x, y)].n = g_iStoneNumber;
}

//删除最后一子
//谨慎使用，本函数不做合理性校验
static void DeleteLastStone(void)
{
    if(g_StoneData[g_iStoneNumber].sn>0) g_iShowStoneNumber--;

    g_BoardData[MAKESITE(g_StoneData[g_iStoneNumber].x, g_StoneData[g_iStoneNumber].y)].c = EMPTY;
    g_BoardData[MAKESITE(g_StoneData[g_iStoneNumber].x, g_StoneData[g_iStoneNumber].y)].n = 0;

    g_StoneData[g_iStoneNumber].x = 0;
    g_StoneData[g_iStoneNumber].y = 0;
    g_StoneData[g_iStoneNumber].c = EMPTY;
    g_StoneData[g_iStoneNumber].n = 0;
    g_StoneData[g_iStoneNumber].sn = 0;
    g_StoneData[g_iStoneNumber].ko = 0;
    g_StoneData[g_iStoneNumber].bk = 0;

    g_iStoneNumber--;
}

//判断最后落子有效性
//   有效则更新棋盘、棋子信息
//返回值：有效切吃子返回 吃子数，有效但无吃子返回 0，无效返回 -1
//   无效包括：禁着点，打劫
static int CheckLastStone(void)
{
    unsigned char i, j;
    unsigned short int ks = 0;     //假定吃子数统计
    STONECOLOR p = OtherColor(g_StoneData[g_iStoneNumber].c);

    //逐棋盘交叉点算气
    //棋盘所有交叉点的气归 1（默认都有气）
    memset(g_NoLiberty, true, sizeof(g_NoLiberty));
    for(i=1; i<=g_iBoardSize; i++)
        for(j=1; j<=g_iBoardSize; j++)
            //只算与最后一手棋反色的，没有气的棋就是被吃掉的
            if(g_BoardData[MAKESITE(i, j)].c==p && GetLiberty(i, j, p)==0)
            {
                ks++;
                g_NoLiberty[MAKESITE(i, j)] = false;
            }
    //只吃了一个子，且吃掉的是上一手棋，而上一手棋只吃了一个子：打劫
    //未吃棋而本子无气：禁着点
    if((ks==1 && g_NoLiberty[MAKESITE(g_StoneData[g_iStoneNumber-1].x, g_StoneData[g_iStoneNumber-1].y)]==0 && g_StoneData[g_iStoneNumber-1].ko==1)
        || (ks==0 && GetLiberty(g_StoneData[g_iStoneNumber].x, g_StoneData[g_iStoneNumber].y, g_StoneData[g_iStoneNumber].c)==0))
        return -1;

    //剩余情况都是有效落子，增补信息
    g_StoneData[g_iStoneNumber].ko = ks;
    for(i=1; i<=g_iBoardSize; i++)
        for(j=1; j<=g_iBoardSize; j++)
            if(g_NoLiberty[MAKESITE(i, j)] == false)
            {
                //被吃子被吃位标志为最后这手棋
                g_StoneData[g_BoardData[MAKESITE(i, j)].n].bk = g_iStoneNumber;

                //被吃子棋盘交叉点清空
                g_BoardData[MAKESITE(i, j)].c = EMPTY;
                g_BoardData[MAKESITE(i, j)].n = 0;
            }

    return ks;
}

//采用递归计算气
//参数：x,y 棋盘上的坐标，c 颜色
//返回值：该交叉点拥有c颜色总气数
//用2进制位表示状态：0没算过 *1算过左边  *2算过右边 *4算过上边 *8算过下边
static int Count(unsigned char x, unsigned char y, STONECOLOR c)
{
    unsigned char i;
    unsigned short int n = 0;

    //棋盘外围，或者全部算完
    if(x<1 || x>g_iBoardSize || y<1 || y>g_iBoardSize || HaveThisState(g_HaveCount[MAKESITE(x, y)], SIDE_ALL))
        return 0;

    //算左边一子
    if(NoThisState(g_HaveCount[MAKESITE(x, y)], SIDE_LEFT))
    {
        g_HaveCount[MAKESITE(x, y)] |= SIDE_LEFT;	            //给左边算过的标志
        i = x -1;                                   //左边子
        if(i>0)                                     //左边子没超出正常棋盘范围
        {
            if(g_BoardData[MAKESITE(i, y)].c == EMPTY)        //左边空位，气加一
                n++;
            else if(g_BoardData[MAKESITE(i, y)].c == c)       //左边子同色，继续往左算
            {
                g_HaveCount[MAKESITE(i, y)] |= SIDE_RIGHT;    //左边子不需往右边算
                n += Count(i, y, c);
            }
        }
    }
    //算右边一子
    if(NoThisState(g_HaveCount[MAKESITE(x, y)], SIDE_RIGHT))
    {
        g_HaveCount[MAKESITE(x, y)] |= SIDE_RIGHT;
        i = x + 1;
        if(i<=g_iBoardSize)
        {
            if(g_BoardData[MAKESITE(i, y)].c == EMPTY)
                n++;
            else if(g_BoardData[MAKESITE(i, y)].c == c)
            {
                g_HaveCount[MAKESITE(i, y)] |= SIDE_LEFT;
                n += Count(i, y, c);
            }
        }
    }
    //算上边一子
    if(NoThisState(g_HaveCount[MAKESITE(x, y)], SIDE_UP))
    {
        g_HaveCount[MAKESITE(x, y)] |= SIDE_UP;
        i = y - 1;
        if(i>0)
        {
            if(g_BoardData[MAKESITE(x, i)].c == EMPTY)
                n++;
            else if(g_BoardData[MAKESITE(x, i)].c == c)
            {
                g_HaveCount[MAKESITE(x, i)] |= SIDE_DOWN;
                n += Count(x, i, c);
            }
        }
    }
    //算下边一子
    if(NoThisState(g_HaveCount[MAKESITE(x, y)], SIDE_DOWN))
    {
        g_HaveCount[MAKESITE(x, y)] |= SIDE_DOWN;
        i = y + 1;
        if(i<=g_iBoardSize)
        {
            if(g_BoardData[MAKESITE(x, i)].c == EMPTY)
                n++;
            else if(g_BoardData[MAKESITE(x, i)].c == c)
            {
                g_HaveCount[MAKESITE(x, i)] |= SIDE_UP;
                n += Count(x, i, c);
            }
        }
    }

    return n;
}
