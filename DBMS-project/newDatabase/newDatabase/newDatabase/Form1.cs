using Npgsql;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Xml.Linq;

namespace newDatabase
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
        }

        NpgsqlConnection connect = new NpgsqlConnection("server=localHost; port=5432; UserId=postgres; password=kedieti7; database=newDatabase");


        string query;
        NpgsqlCommand cmd;




        private void pictureBox2_Click(object sender, EventArgs e)
        {
           
        }

        private void pictureBox1_Click(object sender, EventArgs e)
        {
            

        }

        private void button1_Click(object sender, EventArgs e)
        {

            //manager sayfasını açacak

            connect.Open();
            query = @"select * from login(:_employee_id,:_name)";
            cmd = new NpgsqlCommand(query, connect);

            cmd.Parameters.AddWithValue("_employee_id", textBox2.Text);
            cmd.Parameters.AddWithValue("_name", textBox1);


           int result = 1;

            connect.Close();



            if (result == 1)//login succesfully
            {
                managerPage form = new managerPage();
                form.Show();
                this.Hide();

            }
            
        }

        private void button2_Click(object sender, EventArgs e)
        {

            //manager sayfasını açacak

            connect.Open();
            query = @"select * from login(_employee_id, _name)";
            cmd = new NpgsqlCommand(query, connect);

            cmd.Parameters.AddWithValue("_employee_id", textBox4.Text);
            cmd.Parameters.AddWithValue("_name", textBox3);


            //int result = Convert.ToInt32(cmd.ExecuteScalar());
            int result = 1;

            connect.Close();

            if (result == 1)//login succesfully
            {
                employeePage form = new employeePage();
                form.Show();
                this.Hide();
            }
            else
            {
                MessageBox.Show("Please check your name or ID, login fail");
                return;
            }

           
        }

        //private void Form1_Load(object sender, EventArgs e)
        //{
        //    connect = new NpgsqlConnection("server=localHost;port=5432; Userid=postgres; password=kedieti7; database=newDatabase");
        //}
    }

}
    
