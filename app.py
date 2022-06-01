
from flask import Flask,jsonify
from flask_mysqldb import MySQL
from config import config

import pymysql



app=Flask(__name__)

def db_connection():
    conn=None
    try:
        conn=pymysql.connect(
            host='host',
            database='database',
            user='user',
            password='password',
            charset='charset',
            cursorclass=pymysql.cursors.DictCursor)
    except pymysql.Error as e:
        print(e)
    return conn

@app.route('/main_seq',methods=['GET'])
def main_sequence():
    try:
        conn=db_connection()
        cursor=conn.cursor()
        sql='''SELECT finalRand4 
                FROM fourthentropy'''
        cursor.execute(sql)
        rawdata=cursor.fetchall()
        

        binary_list=[]
        for mini in rawdata:
            binary_list.append(mini['finalRand4'])
        return jsonify(binary_list)

    except Exception as ex:
        return ex


@app.route('/resampled/dice/<seed>&<count>',methods=['GET','POST'])
def sampled_d6(seed,count):
    try:
        die=0
        attempts=0
        while die<1 or die>6:
            conn=db_connection()
            cursor=conn.cursor()
            #CREATE TEMPORARY TABLE temporaryPrivate   
            sql1=f'''CREATE TEMPORARY TABLE temporaryPrivate  
                    SELECT num, 
                            pseudoCombo,
                            rand({seed}) as checker,
                            (CASE WHEN  pseudoCombo = (CASE WHEN rand({seed})>0.5 THEN 1 ELSE 0 END) THEN 1 ELSE 0 END) as returnThis 
                    FROM privateTable;'''
            sql2='''ALTER TABLE temporaryPrivate ADD PRIMARY KEY(num);'''
            sql3=f'''SELECT num, 
                             pseudoCombo,
                             checker,
                             returnThis
                     FROM temporaryPrivate
                     WHERE num >= 3*{int(count)+attempts} AND num < 3*{int(count)+attempts}+3;'''
            sql4='''DROP TABLE temporaryPrivate;'''  
            cursor.execute(sql1)
            cursor.execute(sql2)
            cursor.execute(sql3)
            rawdata=cursor.fetchall()
            cursor.execute(sql4)
            print(rawdata)
            binaryR=''
            for mini in rawdata:
                binaryR=binaryR+str(mini['returnThis'])
            die=int(binaryR, 2)
            attempts=attempts+1
        return jsonify({'binary':binaryR,'decimal':die,'attempts':attempts})
    except Exception as ex:
        return ex



@app.route('/resampled/full_seq/<seed>',methods=['GET'])
def sampled_seq(seed):
    try:
        conn=db_connection()
        cursor=conn.cursor()
        sql=f'''SELECT num, 
                (CASE WHEN  pseudoCombo = (CASE WHEN rand({seed})>0.5 THEN 1 ELSE 0 END) THEN 1 ELSE 0 END) as returnThis
                FROM privateTable;'''
        cursor.execute(sql)
        rawdata=cursor.fetchall()
        binary_list=[]
        for mini in rawdata:
            binary_list.append(mini['returnThis'])
        return jsonify(binary_list)
    except Exception as ex:
        return ex
        


if __name__ == '__main__':
    app.run()




