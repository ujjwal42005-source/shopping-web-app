# conn = pymysql.connect(
#     host='localhost',
#     user='root',
#     password='udmysql@@2005',
#     database='Retail_store',
#     port=3306
# )


from flask import Flask, render_template, request, redirect, url_for,jsonify,json,session
import random
import pymysql
import ast


app = Flask(__name__,static_url_path='/static')

app.secret_key=str(random.randint(0,10000))

# Connect to MySQL database
conn = pymysql.connect(
    host='localhost',
    user='root',
    password='Reapercreeper399',
    database='temp1',
    port=3306
)


@app.route('/')
def index():
    return render_template('wow.html')

li=['customer','shop','Customer']

login_data=[]
current_table=0
@app.route('/searchadmin', methods=['POST','GET'])
def searchadmin():
    print("aaya search admin")
    try:
        global current_table
        data = request.get_json()  # Retrieve JSON data
        print(data)
        cust_name = data['sn']  # Extract searchQuery
        table_num = data['tn']
        page=data['page']

        if table_num!='none':
            current_table=table_num


        print('the cust_name is ',cust_name)
        if conn.open:
            with conn.cursor() as cursor:
                # Use SQL wildcard '%' to match any sequence of characters
                result=''

                if page=="admin":
                    search=""
                    Name=""
                    if(current_table=='0'):
                        search="customer"
                        Name="Name"
                    elif (current_table=='1'):
                        search="Vendor"
                        Name="Name"
                    else:
                        search="Item"
                        Name="Item_Name"
                    query = f"SELECT * FROM "+ search+" WHERE "+Name+" LIKE %s"
                    cursor.execute(query, ('%' + cust_name + '%'))
                elif page=="vendor":
                    print(login_data)
                    query = f"SELECT * FROM Item  WHERE vendor_id = "+str(login_data[0])
                    cursor.execute(query)
                elif page=="cart":
                    name=session["username"]
                    query1=f"SELECT cust_id FROM Customer WHERE email_id = %s "
                    cursor.execute(query1,(name))
                    custid = cursor.fetchall()
                    print("\n\n")
                    print("id",custid[0][0])
                    print("\n\n")

                    cid=str(custid[0][0])
                    query2 = f"SELECT item.* FROM cart INNER JOIN item ON cart.item_id = item.item_id WHERE cart.customer_id = %s"
                    # query=f"SELECT * FROM cart Where customer_id = %s"
                    cursor.execute(query2,cid)
                    
                
                result = cursor.fetchall()  # Fetch all matching records

                print("the res is ",result)
                return jsonify({"res":result,"tn":current_table}) # Pass the result to the template
        else:
            print("Connection to database failed")
            return 'Connection to database failed'
    except Exception as e:
        print("Error:", e)
        return 'An error occurred while fetching data from the database'




@app.route('/button_click', methods=['POST'])
def button_click():
    role = request.form['role']
    if role=='admin':
        li[0]='admin'
        li[2] = 'Admin'
        li[1]="admin"
    elif role == 'vendor':
        li[0]='vendor'
        li[2] = 'Vendor'
        li[1]="vendorpage"
    elif role == 'customer':
        print("hello cutomer")
        li[0]='customer'
        li[2] = 'Customer'
        li[1]="shop"
    else:
        print('Invalid role')
    print("button click ",role)
    return role

print("print is ",li[1])

checklogin=0

@app.route('/login', methods=['GET', 'POST'])
def login():
    print("camehere1")
    global login_data
    if request.method == 'POST':
        # role = request.form['adminForm']
        username = request.form[li[0]+'Username']
        password = request.form[li[0]+'Password']
        session["username"]=username
        session["password"]=password

        print("camehere2")
        print(username+" "+password+" "+li[0])
        try:
            if conn.open:
                with conn.cursor() as cursor:
                    if(li[0]=="customer"):
                        query = f"SELECT * FROM {li[2]} WHERE email_id=%s AND Cust_pass=%s"
                    elif (li[0]=="vendor"):
                        query = f"SELECT * FROM {li[2]} WHERE Name=%s AND Passwd=%s"
                    else:
                        query = f"SELECT * FROM {li[2]} WHERE Mail=%s AND Pass=%s"
                    cursor.execute(query, (username, password))
                    user = cursor.fetchone()
                    login_data=user
                    print("the user is ",user)
                    if user:
                        print("camehere3")
                        # Redirect to dashboard or specific page based on role
                        return redirect(url_for(li[0]+"_dashboard",parameter=username))
                    else:
                        global checklogin
                        if(checklogin<2):
                            checklogin+=1
                            print(checklogin)
                            return redirect("/login")
                        else:
                            return "cv blocked"
            else:
                return 'Connection to database failed'
        except Exception as e:
            print("Error:", e)

    return render_template('wow.html') #

@app.route("/admin_dashboard<parameter>",methods=['GET', 'POST'])
def admin_dashboard(parameter):
    try:
        return render_template('admin.html')
    except Exception as e:
        print("Error:", e)
        return 'An error occurred while fetching data from the database'


@app.route('/additem', methods=['GET', 'POST'])
def additem():
    # Add logic for vendor dashboard
    if request.method == 'POST':
        # role = request.form['adminForm']
        Itemname = request.form['ItemName']
        Stock = request.form['Stock']
        ItemPrice = request.form['ItemPrice']
        Category_id = request.form['CategoryId']
        try:
            if conn.open:
                with conn.cursor() as cursor:
                        query = "INSERT INTO Item (Item_name, stock, Item_price, category_id,vendor_id) VALUES (%s, %s, %s, %s,%s)"
                        values = (Itemname, Stock, ItemPrice, Category_id,str(login_data[0]))
                        cursor.execute(query, values)
                        conn.commit()
                        # Close the cursor and connection

        except Exception as e:
            print("Error:", e)               
    print("inside vendor")
    return render_template('vendorpage.html')

@app.route('/loadshop', methods=['GET', 'POST'])
def loadshop():
        print("inside loadshop bruh")
        try:
            if conn.open:
                with conn.cursor() as cursor:
                        query = "SELECT Item_name,Item_id from Item"
                        cursor.execute(query)
                        data=cursor.fetchall()
                        print(data)
                        return jsonify(data)
                        # Close the cursor and connection

        except Exception as e:
            print("Error:", e)     


@app.route('/product', methods=['POST'])
def product():
    try:
        data1 = request.get_json()
        print("the data1 is ", data1)
        if data1:  # Check if data1 is not empty
            item_id = data1.get('id')  # Assuming 'item_id' is the key in the JSON data
            if item_id is not None:  # Ensure item_id is provided in the JSON data
                session["itemid"]=item_id
                with conn.cursor() as cursor:
                    query = f"SELECT * FROM Item WHERE Item_id = {item_id}"
                    cursor.execute(query)
                    data2 = cursor.fetchone()  # Assuming you expect only one row
                    if data2:
                        # Construct a dictionary from the fetched data
                        data = {
                            "id": data2[0],
                            "name": data2[1],
                            "stock": data2[2],
                            "price": data2[3]
                        }
                        print("Fetched data:", data)
                        # Pass the dictionary directly to url_for
                        return jsonify({'redirect_url': url_for('render_product', data=data)})
                    else:
                        return jsonify({'error': 'Item not found'}), 404
            else:
                return jsonify({'error': 'Item ID not provided in JSON data'}), 400
        else:
            return jsonify({'error': 'Empty or invalid JSON data received'}), 400
    except Exception as e:
        print("Error:", e)
        return jsonify({'error': 'An unexpected error occurred'}), 500

@app.route('/render_product', methods=['GET', 'POST'])
def render_product():
    data_str = request.args.get('data')
    data= ast.literal_eval(data_str)
    print("the render data is ", data)
    return render_template("product.html", data=data)

@app.route('/gotohome', methods=['GET', 'POST'])
def gotohome():
    return render_template('/wow.html')

@app.route('/gotoshop', methods=['GET', 'POST'])
def gotoshop():
    return render_template('/shop.html')


@app.route('/vendor_dashboard<parameter>', methods=['GET', 'POST'])
def vendor_dashboard(parameter):
    # Add logic for vendor dashboard
    print("inside vendor")
    return render_template('vendorpage.html',data={1,2,3})



@app.route('/customer_dashboard/<parameter>', methods=['GET', 'POST'])
def customer_dashboard(parameter):
    # Add logic for customer dashboard
    print("camhere also")
    print(parameter)
    return render_template('shop.html',data=parameter)

@app.route('/gotocart', methods=['GET', 'POST'])
def gotocart():
    return render_template('/cart.html')

@app.route('/orderitem', methods=['GET', 'POST'])
def orderitem():
    maindata=request.get_json()
    tempdata=maindata['orders']
    print(maindata['orders'])
    return jsonify({"res":tempdata})



@app.route('/addtocart', methods=['GET', 'POST'])
def addtocart():
        item = session["itemid"]
        cust_name = session["username"]
        
        cursor = conn.cursor()
        cursor.execute("INSERT INTO cart (item_id, customer_id) VALUES (%s, (SELECT cust_id FROM Customer WHERE email_id = %s))", (item, cust_name))
        conn.commit()
        return render_template('shop.html') 


if __name__ == '__main__':
    app.run(debug=True,port=5003)
