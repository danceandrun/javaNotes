create table student(sid varchar(10),sname varchar(10),sage datetime,ssex varchar(10));
insert into student values('01' , '赵雷' , '1990-01-01' , '男');
insert into student values('02' , '钱电' , '1990-12-21' , '男');
insert into student values('03' , '孙风' , '1990-05-20' , '男');
insert into student values('04' , '李云' , '1990-08-06' , '男');
insert into student values('05' , '周梅' , '1991-12-01' , '女');
insert into student values('06' , '吴兰' , '1992-03-01' , '女');
insert into student values('07' , '郑竹' , '1989-07-01' , '女');
insert into student values('08' , '王菊' , '1990-01-20' , '女');


create table course(cid varchar(10),cname varchar(10),tid varchar(10));
insert into course values('01' , '语文' , '02');
insert into course values('02' , '数学' , '01');
insert into course values('03' , '英语' , '03');


create table teacher(Tid varchar(10),Tname varchar(10));
insert into teacher values('01' , '张三');
insert into teacher values('02' , '李四');
insert into teacher values('03' , '王五');


create table sc(Sid varchar(10),Cid varchar(10),score decimal(18,1));
insert into sc values('01' , '01' , 80);
insert into sc values('01' , '02' , 90);
insert into sc values('01' , '03' , 99);
insert into sc values('02' , '01' , 70);
insert into sc values('02' , '02' , 60);
insert into sc values('02' , '03' , 80);
insert into sc values('03' , '01' , 80);
insert into sc values('03' , '02' , 80);
insert into sc values('03' , '03' , 80);
insert into sc values('04' , '01' , 50);
insert into sc values('04' , '02' , 30);
insert into sc values('04' , '03' , 20);
insert into sc values('05' , '01' , 76);
insert into sc values('05' , '02' , 87);
insert into sc values('06' , '01' , 31);
insert into sc values('06' , '03' , 34);
insert into sc values('07' , '02' , 89);
insert into sc values('07' , '03' , 98);



-- 1. 查询" 01 "课程比" 02 "课程成绩高的学生的信息及课程分数
TODO

-- 1.1 查询同时存在" 01 "课程和" 02 "课程的情况
select * from sc s1 inner join sc s2 on s1.sid=s2.sid and s1.cid='01' and s2.cid='02';
-- 1.2 查询存在" 01 "课程但可能不存在" 02 "课程的情况(不存在时显示为 null )
select t1.sid,t1.score as t1_score,t2.score as t2_score from (select * from sc where cid='01') as t1 left join (select * from sc where cid='01') as t2 on t1.sid=t2.sid;
-- 1.3 查询不存在" 01 "课程但存在" 02 "课程的情况
(select * from sc group by cid having cid='02') as t1 left join (select * from sc group by cid having cid='01') as t2 
-- 2. 查询平均成绩大于等于 60 分的同学的学生编号和学生姓名和平均成绩
select s.sid, s.sname, sc.avg from student s right join (select sid, avg(score) as avg from sc group by sid ) as sc on s.sid=sc.sid;
-- 3. 查询在 SC 表存在成绩的学生信息
-- 答案
select distinct s.* from Student s right join SC S2 on s.SId = S2.SId;

-- 4. 查询所有同学的学生编号、学生姓名、选课总数、所有课程的总成绩(没成绩的显示为 null )
select s.sid, s.sname, count(1) as total_cource, sum(s2.score) from student s left join sc s2 on s.sid=s2.sid group by s.sid,s.sname; 
-- 答案
select s.SId, s.Sname, count(1) as total_cource, sum(S2.score)
from Student s
         left join SC S2 on s.SId = S2.SId
group by s.SId, s.Sname;
-- 4.1 查有成绩的学生信息
select distinct s.* from student s right join sc on s.sid=sc.sid;

-- 5. 查询「李」姓老师的数量
select count(1) from teacher where tname like '李%';
-- 6. 查询学过「张三」老师授课的同学的信息
--     public Object list(HttpServletRequest req, HttpServletResponse resp) {
        SqlSession sqlSession = MybatisUtil.getSqlSession(true);
        RegionMapper mapper = sqlSession.getMapper(RegionMapper.class);
        List<Region> regionList = mapper.selectAll();
        // 使用流解决
        List<Region> provinceList = regionList.stream().filter(region -> region.getType() == 1).collect(Collectors.toList());
        List<Region> cityList = regionList.stream().filter(region -> region.getType() == 2).collect(Collectors.toList());
        // 将3级地区放入2级地区
        for (Region region : cityList) {
            Integer cityId = region.getId();
            List<Region> localAreaOfCity = regionList.stream().filter(localArea -> (localArea.getType() == 3) && (localArea.getPid() == cityId)).collect(Collectors.toList());
            region.setChildren(localAreaOfCity);
        }
        // 将2级地区放入1级地区
        for (Region region : provinceList) {
            Integer provinceId = region.getId();
            List<Region> cityOfProvince = regionList.stream().filter(city -> (city.getType() == 2) && (city.getPid() == provinceId)).collect(Collectors.toList());
            region.setChildren(cityOfProvince);
        }
        return BaseRespVo.okList(provinceList);
    }
-- 7. 查询没有学全所有课程的同学的信息
-- 
-- 8. 查询至少有一门课与学号为" 01 "的同学所学相同的同学的信息
-- 
-- 9. 查询和" 01 "号的同学学习的课程完全相同的其他同学的信息
-- 
-- 10. 查询没学过"张三"老师讲授的任一门课程的学生姓名
-- 
-- 11. 查询两门及其以上不及格课程的同学的学号，姓名及其平均成绩
-- 
-- 12. 检索" 01 "课程分数小于 60，按分数降序排列的学生信息
-- 
-- 13. 按平均成绩从高到低显示所有学生的所有课程的成绩以及平均成绩
-- 
-- 14. 查询各科成绩最高分、最低分和平均分：
-- 
--     以如下形式显示：课程 ID，课程 name，最高分，最低分，平均分，及格率，中等率，优良率，优秀率
--     及格为>=60，中等为：70-80，优良为：80-90，优秀为：>=90
--     要求输出课程号和选修人数，查询结果按人数降序排列，若人数相同，按课程号升序排列
-- 
-- 15. 按各科成绩进行排序，并显示排名， Score 重复时保留名次空缺
-- 
-- 15.1 按各科成绩进行排序，并显示排名， Score 重复时合并名次
-- 
-- 16.  查询学生的总成绩，并进行排名，总分重复时保留名次空缺
-- 
-- 16.1 查询学生的总成绩，并进行排名，总分重复时不保留名次空缺
-- 
-- 17. 统计各科成绩各分数段人数：课程编号，课程名称，[100-85]，[85-70]，[70-60]，[60-0] 及所占百分比
-- 
-- 18. 查询各科成绩前三名的记录
-- 
-- 19. 查询每门课程被选修的学生数
-- 
-- 20. 查询出只选修两门课程的学生学号和姓名
-- 
-- 21. 查询男生、女生人数
-- 
-- 22. 查询名字中含有「风」字的学生信息
-- 
-- 23. 查询同名同性学生名单，并统计同名人数
-- 
-- 24. 查询 1990 年出生的学生名单
-- 
-- 25. 查询每门课程的平均成绩，结果按平均成绩降序排列，平均成绩相同时，按课程编号升序排列
-- 
-- 26. 查询平均成绩大于等于 85 的所有学生的学号、姓名和平均成绩
-- 
-- 27. 查询课程名称为「数学」，且分数低于 60 的学生姓名和分数
-- 
-- 28. 查询所有学生的课程及分数情况（存在学生没成绩，没选课的情况）
-- 
-- 29. 查询任何一门课程成绩在 70 分以上的姓名、课程名称和分数
-- 
-- 30. 查询不及格的课程
-- 
-- 31. 查询课程编号为 01 且课程成绩在 80 分以上的学生的学号和姓名
-- 
-- 32. 求每门课程的学生人数
-- 
-- 33. 成绩不重复，查询选修「张三」老师所授课程的学生中，成绩最高的学生信息及其成绩
-- 
-- 34. 成绩有重复的情况下，查询选修「张三」老师所授课程的学生中，成绩最高的学生信息及其成绩
-- 
-- 35. 查询不同课程成绩相同的学生的学生编号、课程编号、学生成绩
-- 
-- 36. 查询每门功成绩最好的前两名
-- 
-- 37. 统计每门课程的学生选修人数（超过 5 人的课程才统计）。
-- 
-- 38. 检索至少选修两门课程的学生学号
-- 
-- 39. 查询选修了全部课程的学生信息
-- 
-- 40. 查询各学生的年龄，只按年份来算
-- 
-- 41. 按照出生日期来算，当前月日 < 出生年月的月日则，年龄减一
-- 
-- 42. 查询本周过生日的学生
-- 
-- 43. 查询下周过生日的学生
-- 
-- 44. 查询本月过生日的学生
-- 
-- 45. 查询下月过生日的学生