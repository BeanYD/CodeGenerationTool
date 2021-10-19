#include <string.h>
#include "GoBoard.h"


int g_iBoardSize = 19;                                //��������
BOARDDATA g_BoardData[MAX_BOARDSIZE*MAX_BOARDSIZE];   //����״̬����

int g_iStoneNumber, g_iShowStoneNumber;               //����������������ʾ��
STONECOLOR g_cNextColor = BLACK;                      //��һ�������ɫ
STONEDATA g_StoneData[MAX_STONENUMBER];               //������Ϣ����

int g_iBackStoneNumber;               				  //���ӱ���������
STONEDATA g_BackStoneData[MAX_STONENUMBER];           //����������Ϣ����

int g_iTempStoneNumber;               				  //��ʱ���ӱ���������

STONECOLOR g_BoardExam0[MAX_BOARDSIZE*MAX_BOARDSIZE];          //��Ŀ״̬���������ʵ������ɫ
STONECOLOR g_BoardExam2[MAX_BOARDSIZE*MAX_BOARDSIZE];          //��Ŀ״̬�������������ɫ
static STONECOLOR g_BoardExam1[MAX_BOARDSIZE*MAX_BOARDSIZE];   //��Ŀ״��ɫ���ӱ���

static DIRECTION g_HaveCount[MAX_BOARDSIZE*MAX_BOARDSIZE];     //������Ѱ��ͬɫ�ӵķ����־
static bool g_NoLiberty[MAX_BOARDSIZE*MAX_BOARDSIZE];          //�����������־


static int Count(unsigned char, unsigned char, STONECOLOR);
static int CheckLastStone(void);

static void FindSameInBoardExam0(unsigned char, unsigned char, STONECOLOR, bool);
static STONECOLOR DecideCrossColor(unsigned char, unsigned char, STONECOLOR *p);

static void AddOneStone(unsigned char, unsigned char, STONECOLOR, bool);
static void DeleteLastStone(void);


//�������״̬����
extern void ClearBoardData(void)
{
    unsigned char i, j;

    //����������ȫ����0
    memset(g_BoardData, 0, sizeof(g_BoardData));
    //������Χ��ɫ�� -1
    j = g_iBoardSize+1;
    for(i=0; i<=j; i++)
    {
        g_BoardData[i].c = GREY;
        g_BoardData[MAKESITE(j, i)].c = GREY;
        g_BoardData[MAKESITE(i, 0)].c = GREY;
        g_BoardData[MAKESITE(i, j)].c = GREY;
    }
}

//���������Ϣ����
extern void ClearStoneData(void)
{
    g_iStoneNumber = g_iShowStoneNumber = 0;
    g_cNextColor = BLACK;
    memset(g_StoneData, 0, sizeof(g_StoneData));
}

//����������Ϣ����
extern void CopyStoneData(void)
{
    g_iBackStoneNumber = g_iStoneNumber;
    memcpy(g_BackStoneData, g_StoneData, sizeof(STONEDATA)*MAX_STONENUMBER);
}

//ɨ�� g_BoardExam��ȡ�úڰ׸�ɫ����
extern void ScanBoardExam(int *b, int *w, int *e)
{
    unsigned char i, j;

    *b = *w = *e = 0;

    //����ʵ����ȷ����ɫ������
    for(i=1; i<=g_iBoardSize; i++)
        for(j=1; j<=g_iBoardSize; j++)
            g_BoardExam1[MAKESITE(i, j)] = DecideCrossColor(i, j, g_BoardExam0);

    //ȷ����ɫ�������ڿո������ɫ
    for(i=1; i<=g_iBoardSize; i++)
        for(j=1; j<=g_iBoardSize; j++)
            g_BoardExam2[MAKESITE(i, j)] = DecideCrossColor(i, j, g_BoardExam1);

    //ɨ��ȫ������
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

//��ʼ����Ŀ״̬���������ʵ������ɫ
extern void InitBoardExam0(void)
{
    unsigned char i, j;
    //��������
    for(i=1; i<=g_iBoardSize; i++)
        for(j=1; j<=g_iBoardSize; j++)
            g_BoardExam0[MAKESITE(i, j)] = g_BoardData[MAKESITE(i, j)].c;
}

//��ʼ�� g_BoardExam0
extern void InvertBoardExam0(unsigned char x, unsigned char y)
{
    memset(g_HaveCount, SIDE_NONE, sizeof(g_HaveCount));
    g_BoardExam0[MAKESITE(x, y)] = OtherColor(g_BoardExam0[MAKESITE(x, y)]);
    FindSameInBoardExam0(x, y, g_BoardData[MAKESITE(x, y)].c, g_BoardExam0[MAKESITE(x, y)]!=g_BoardData[MAKESITE(x, y)].c);
}

//�ı��Ŀ״̬���������ʵ������ɫ
//��2����λ��ʾ״̬��0û��� *1������  *2����ұ� *4����ϱ� *8����±�
static void FindSameInBoardExam0(unsigned char x, unsigned char y, STONECOLOR c, bool b)
{
    unsigned char i;

    //������Χ������ȫ������
    if(x<1 || x>g_iBoardSize || y<1 || y>g_iBoardSize || HaveThisState(g_HaveCount[MAKESITE(x, y)], SIDE_ALL))
        return;

    //�����һ��
    if(NoThisState(g_HaveCount[MAKESITE(x, y)], SIDE_LEFT))
    {
        g_HaveCount[MAKESITE(x, y)] |= SIDE_LEFT;                      //��������ҹ��ı�־
        i = x -1;                                            //�����
        if(i>0)                                              //�����û�����������̷�Χ
        {
            if(g_BoardData[MAKESITE(i, y)].c == c)                     //�����ͬɫ������������
            {
                g_HaveCount[MAKESITE(i, y)] |= SIDE_RIGHT;             //����Ӳ������ұ���
                g_BoardExam0[MAKESITE(i, y)] = b ? OtherColor(c) : c;
                FindSameInBoardExam0(i, y, c, b);
            }
        }
    }
    //���ұ�һ��
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
    //���ϱ�һ��
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
    //���±�һ��
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

//��Ŀ״̬ȷ���ո�λ�ù�����ɫ
static STONECOLOR DecideCrossColor(unsigned char x, unsigned char y, STONECOLOR *p)
{
    STONECOLOR c[4], r = EMPTY;
    unsigned char i;

    //�����������
    if(p[MAKESITE(x, y)] != EMPTY)
        return p[MAKESITE(x, y)];
    //�����Ϊ�ո����ж���4��������������ӵ���ɫ
    //������
    i = x;
    while(p[MAKESITE(i, y)] == EMPTY && i > 0)
        i--;
    c[0] = p[MAKESITE(i, y)];
    //���Ҽ��
    i = x;
    while(p[MAKESITE(i, y)] == EMPTY && i <= g_iBoardSize)
        i++;
    c[1] = p[MAKESITE(i, y)];
    //���ϼ��
    i = y;
    while(p[MAKESITE(x, i)] == EMPTY && i > 0)
        i--;
    c[2] = p[MAKESITE(x, i)];
    //���¼��
    i = y;
    while(p[MAKESITE(x, i)] == EMPTY && i <= g_iBoardSize)
        i++;
    c[3] = p[MAKESITE(x, i)];
    //�ÿո�����4����������ӵ���ɫһ�£��Ҳ����ǿո���ÿո����ڸ�ɫ��������Ϊ����
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

//����һ����
//������x y �����߼����꣬c ������ɫ��b �Ƿ�������ʾ����
//����ֵ����Ч�򷵻س����������֣�������٣�����-1 ����ǰ�����ӷ���-2
extern int PlayStone(unsigned char x, unsigned char y, STONECOLOR c, bool b)
{
    int i;

    //����ǿ�λ
    if(g_BoardData[MAKESITE(x, y)].c != EMPTY)
        return -2;

    //������һ��
    AddOneStone(x, y, c, b);
    //�����Ч�ԣ���Чʱ�Ѿ��������� ��
    i = CheckLastStone();
    if(i >= 0)
    {
        //������ʾ�����Ļ����������ӣ���Ҫ�ı���һ�ֵ���ɫ
        if(b) g_cNextColor = OtherColor(g_cNextColor);
        return i;
    }
    else    //��Ч��ɾ��
    {
        DeleteLastStone();
        return -1;
    }
}

//����һ��
//����ֵ���ɹ�����1�����򷵻�0
extern bool WithdrawOneStep(void)
{
    if(g_iStoneNumber > 0)
    {
        //�����һ�ӳԵ����廹ԭ
        int i;
        for(i=1; i<g_iStoneNumber; i++)
            if(g_StoneData[i].bk == g_iStoneNumber)
            {
                g_StoneData[i].bk = 0;
                g_BoardData[MAKESITE(g_StoneData[i].x, g_StoneData[i].y)].n = g_StoneData[i].n;
                g_BoardData[MAKESITE(g_StoneData[i].x, g_StoneData[i].y)].c = g_StoneData[i].c;
            }
        //��һ�ֱ�ɫ������Ϊ�̶����򲻱�
        if(g_StoneData[g_iStoneNumber].sn>0)
            g_cNextColor =  g_iStoneNumber>0 ? OtherColor(g_cNextColor) : BLACK;
        //ɾ�����һ��
        DeleteLastStone();
        return true;
    }
    return false;
}

//�����
//������x y ���̵��߼����꣬c ������ɫ
//����ֵ��x y������C��ɫ��������
extern int GetLiberty(unsigned char x, unsigned char y, STONECOLOR c)
{
    //�����ı�־λ�� 1
    memset(g_HaveCount, SIDE_NONE, sizeof(g_HaveCount));
    return Count(x, y, c);
}

//����һ��
//������x,y �����������ϵ����꣬c ������ɫ��b �Ƿ����ʾ����
//����ʹ�ã�����������������У��
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

//ɾ�����һ��
//����ʹ�ã�����������������У��
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

//�ж����������Ч��
//   ��Ч��������̡�������Ϣ
//����ֵ����Ч�г��ӷ��� ����������Ч���޳��ӷ��� 0����Ч���� -1
//   ��Ч���������ŵ㣬���
static int CheckLastStone(void)
{
    unsigned char i, j;
    unsigned short int ks = 0;     //�ٶ�������ͳ��
    STONECOLOR p = OtherColor(g_StoneData[g_iStoneNumber].c);

    //�����̽��������
    //�������н��������� 1��Ĭ�϶�������
    memset(g_NoLiberty, true, sizeof(g_NoLiberty));
    for(i=1; i<=g_iBoardSize; i++)
        for(j=1; j<=g_iBoardSize; j++)
            //ֻ�������һ���巴ɫ�ģ�û����������Ǳ��Ե���
            if(g_BoardData[MAKESITE(i, j)].c==p && GetLiberty(i, j, p)==0)
            {
                ks++;
                g_NoLiberty[MAKESITE(i, j)] = false;
            }
    //ֻ����һ���ӣ��ҳԵ�������һ���壬����һ����ֻ����һ���ӣ����
    //δ������������������ŵ�
    if((ks==1 && g_NoLiberty[MAKESITE(g_StoneData[g_iStoneNumber-1].x, g_StoneData[g_iStoneNumber-1].y)]==0 && g_StoneData[g_iStoneNumber-1].ko==1)
        || (ks==0 && GetLiberty(g_StoneData[g_iStoneNumber].x, g_StoneData[g_iStoneNumber].y, g_StoneData[g_iStoneNumber].c)==0))
        return -1;

    //ʣ�����������Ч���ӣ�������Ϣ
    g_StoneData[g_iStoneNumber].ko = ks;
    for(i=1; i<=g_iBoardSize; i++)
        for(j=1; j<=g_iBoardSize; j++)
            if(g_NoLiberty[MAKESITE(i, j)] == false)
            {
                //�����ӱ���λ��־Ϊ���������
                g_StoneData[g_BoardData[MAKESITE(i, j)].n].bk = g_iStoneNumber;

                //���������̽�������
                g_BoardData[MAKESITE(i, j)].c = EMPTY;
                g_BoardData[MAKESITE(i, j)].n = 0;
            }

    return ks;
}

//���õݹ������
//������x,y �����ϵ����꣬c ��ɫ
//����ֵ���ý����ӵ��c��ɫ������
//��2����λ��ʾ״̬��0û��� *1������  *2����ұ� *4����ϱ� *8����±�
static int Count(unsigned char x, unsigned char y, STONECOLOR c)
{
    unsigned char i;
    unsigned short int n = 0;

    //������Χ������ȫ������
    if(x<1 || x>g_iBoardSize || y<1 || y>g_iBoardSize || HaveThisState(g_HaveCount[MAKESITE(x, y)], SIDE_ALL))
        return 0;

    //�����һ��
    if(NoThisState(g_HaveCount[MAKESITE(x, y)], SIDE_LEFT))
    {
        g_HaveCount[MAKESITE(x, y)] |= SIDE_LEFT;	            //���������ı�־
        i = x -1;                                   //�����
        if(i>0)                                     //�����û�����������̷�Χ
        {
            if(g_BoardData[MAKESITE(i, y)].c == EMPTY)        //��߿�λ������һ
                n++;
            else if(g_BoardData[MAKESITE(i, y)].c == c)       //�����ͬɫ������������
            {
                g_HaveCount[MAKESITE(i, y)] |= SIDE_RIGHT;    //����Ӳ������ұ���
                n += Count(i, y, c);
            }
        }
    }
    //���ұ�һ��
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
    //���ϱ�һ��
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
    //���±�һ��
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
