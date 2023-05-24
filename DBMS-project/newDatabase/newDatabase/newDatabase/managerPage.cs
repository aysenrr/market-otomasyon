using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace newDatabase
{
    public partial class managerPage : Form
    {
        public managerPage()
        {
            InitializeComponent();
        }

        private void pictureBox1_Click(object sender, EventArgs e)
        {
            //supplier sayfasına yönlendircek
            managerSupplier form=new managerSupplier();
            form.Show();
            this.Hide();


        }

        private void pictureBox2_Click(object sender, EventArgs e)
        {
            //employee sayfasına yönlendircek

            managerEmployee form=new managerEmployee();
            form.Show();
            this.Hide();


        }

        private void pictureBox3_Click(object sender, EventArgs e)
        {
           
        }

        private void pictureBox4_Click(object sender, EventArgs e)
        {
            
        }

        private void button1_Click(object sender, EventArgs e)
        {
            Form1 form=new Form1();
            form.Show();
            this.Hide();

        }
    }
}
